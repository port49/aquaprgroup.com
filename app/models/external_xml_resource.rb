class ExternalXmlResource < ActiveRecord::Base

  def load
    # first time fetching data or data has expired
    if self.xml.nil? || (Time.now.to_i - self.refresh_rate > self.updated_at.to_i)
      self.refresh!

    # data is cached
    else
      return true
    end
  end

  def refresh!
    # refresh! will rarely (if ever) be called on a new record,
    # but we need to have an id, so save it first
    begin
      self.save if self.new_record?
    rescue 
      raise self.inspect
    end
    # check if this record is updating already, and if not, set
    # this record as updating, all within a transaction so that 
    # we don't have a race condition trying to update the xml
    refresh_xml = false
    self.transaction do
      self.reload
      unless self.refreshing
        self.update_attributes!(:refreshing => true)
        refresh_xml = true
      end
    end

    # we are cleared to update the xml
    if refresh_xml
      self.force_refresh!
    end
  end

  def force_refresh!
    self.xml = open(self.url).read
    self.refreshing = false
    self.save!
  end

end
