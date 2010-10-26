# Workflow class (based on convenient_dictionary plugin) is implied in this system of Revisions.
module Revisionality
  # Bootstrap the class methods.
  def self.included( klass )
    klass.extend ClassMethods

    klass.named_scope :resource, lambda { |resource_id| { :conditions => { :resource_id => resource_id } } }
    klass.named_scope :published, :conditions => { :workflow_id => Workflow.published.to_i }
    klass.named_scope :pending, :conditions => { :workflow_id => Workflow.pending.to_i }
    klass.named_scope :expired, :conditions => { :workflow_id => Workflow.expired.to_i }, :order => "revision_history DESC"
    klass.named_scope :deleted, :conditions => { :workflow_id => Workflow.deleted.to_i }
  end
  
#
# Class Methods.
#
  module ClassMethods

    # This must be used instead of new / save, otherwise there could be a race condition
    # for fetching the new resource_id.
    def create( attributes = nil, &block )
      if attributes.is_a?(Array)
        attributes.collect { |attr| self.create(attr, &block) }
      else
        transaction do
          # Set default workflow.
          attributes[:resource_id] ||= new_resource_id
          attributes[:workflow_id] = Workflow.pending
          attributes[:current] = false
          super( attributes, &block )
        end
      end
    end

    # This must be used instead of new / save!, otherwise there could be a race condition
    # for fetching the new resource_id.
    def create!( attributes = nil, &block )
      if attributes.is_a?(Array)
        attributes.collect { |attr| self.create!(attr, &block) }
      else
        transaction do
          # Set default workflow.
          attributes[:resource_id] ||= new_resource_id
          attributes[:workflow_id] = Workflow.pending
          attributes[:current] = false
          super( attributes, &block )
        end
      end
    end
    
    def new_resource_id
      ( maximum( :resource_id ) || 0 ) + 1
    end
  
  end

#
# Instance Methods.
#
  # This is now going to return the object, not true/false.
  def update_attributes( attributes )
    # We prevent the changing of workflow here, because we want to explicitly control that in the helper methods.
    attributes = attributes.merge( { :workflow_id => self.workflow, :resource_id => self.resource_id } )
    self.class.transaction do
      case self.workflow
      # For a pending record, just save changes directly to this record.
      when Workflow.pending
        super( attributes.merge(:current => false) )
        return self
      # For a published record, create a new pending record and return it.
      when Workflow.published
        super( attributes )
        return self
      else
        super( attributes )
        return self
      end
    end
  end

  # This is now going to return the object, not true/false.
  def update_attributes!( attributes )
    # We prevent the changing of workflow here, because we want to explicitly control that in the helper methods.
    attributes = attributes.merge( { :workflow_id => self.workflow, :resource_id => self.resource_id } )
    self.class.transaction do
      case self.workflow
      # For a pending record, just save changes directly to this record.
      when Workflow.pending
        super( attributes.merge(:current => (attributes[:current] || false ) ) )
        return self
      # For a published record, create a new pending record and return it.
      when Workflow.published
        super( attributes )
        return self
      else
        super( attributes )
        return self
      end
    end
  end

  def before_publish; end
  def after_publish; end
  
  def publish!
    self.class.transaction do
      self.before_publish
      if published = self.resource.published.first
        # Do newly expired get the old associations?
        newly_expired = self.class.new( published.attributes.merge( :workflow_id => Workflow.expired, :revision_history => self.new_revision_history ) )
        newly_expired.save
        published.update_attributes( self.attributes.merge( :workflow_id => Workflow.published ) )
      else
        published = self.class.new( self.attributes.merge( :workflow_id => Workflow.published ) )
        published.save
      end
      self.class.revision_clonables.each do |clonable|
        case self.send( clonable ).class.name
        when 'Array'
          self.send( clonable.to_sym ).reload
          if self.send( clonable.to_sym ).length > 0
            published.send( ( clonable.to_s + "=" ).to_sym, self.send( clonable.to_sym ).collect{ |clone_me| clone_me.clone } )
          else
            published.send( ( clonable.to_s + "=" ).to_sym, [] )
          end
        else
          if !self.send( clonable.to_sym ).nil?
            published.send( ( clonable.to_s + "=" ).to_sym, self.send( clonable.to_sym ).clone )
          end
        end
      end
      self.current = true
      self.save!
      self.after_publish
    end
  end
  
  def new_revision_history
    ( self.resource.maximum( :revision_history ) || 0 ) + 1
  end
  
  def revert_to_revision( revision )
    attributes = revision.attributes.merge( :workflow_id => Workflow.pending, :revision_history => nil )
    attributes = revision.attributes.merge( :current => true ) if revision.workflow == Workflow.published
    self.update_attributes!( attributes )
  end

  def revert!
    self.revert_to_revision( self.resource.published.first )
  end
  
  def destroy
    # This depends on the nobility behavior.
    if self.class.respond_to? 'noble_records'
      raise ActiveRecord::ActiveRecordError if self.class.noble_records.collect( &:resource_id ).include?( self.resource_id )
    end
    published = self.resource.published.first
    unless published.nil?
      published.workflow = Workflow.deleted 
      published.save
      # This is necessary to trigger callbacks to kill associations.
      published.after_destroy
    end
    super
  end

  def resource
    self.class.resource( self.resource_id )
  end
  
  def published_resource
    self.resource.published.first
  end
  
  def pending_resource
    self.resource.pending.first
  end
  
  def is_published?
    self.workflow == Workflow.published
  end

  def workflow
    Workflow.fetch( self.workflow_id )
  end

  def workflow=( workflow_instance )
    case workflow_instance.class.name
    when "Workflow"
      self.workflow_id = workflow_instance.id
    when "Fixnum"
      self.workflow_id = workflow_instance
    end
  end
  
  def sync_to_and_through(association_class, through_class)
    associations = association_class.table_name
    association = association_class.table_name.singularize
    throughs = through_class.table_name
    through = through_class.table_name.singularize
    resources = self.class.table_name
    resource = self.class.table_name.singularize
    association_ids = self.class.connection.select_all(<<-SQL
      SELECT #{associations}.id
        FROM #{associations}
          JOIN #{throughs} ON #{associations}.id=#{throughs}.#{association}_id
          JOIN #{resources} ON #{resources}.id=#{throughs}.#{resource}_id
        WHERE
          #{resources}.id=#{self.published_resource.id}
          AND #{associations}.workflow_id=#{Workflow.pending.id}
      UNION
      SELECT #{associations}.id
        FROM #{associations}
          JOIN #{throughs} ON #{associations}.id=#{throughs}.#{association}_id
          JOIN #{resources} ON #{resources}.id=#{throughs}.#{resource}_id
        WHERE
          #{resources}.id=#{self.id}
          AND #{associations}.workflow_id=#{Workflow.published.id}
    SQL
    ).collect{|r| r['id']}
    self.published_resource.send("#{associations}=".to_sym, association_class.find(association_ids))
  end

end
