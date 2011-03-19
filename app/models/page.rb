class Page < ActiveRecord::Base
  include Pendable

  belongs_to :parent, :class_name => 'Page'
  has_many :children, :class_name => 'Page', :foreign_key => 'parent_id', :conditions => "parent_id!=id", :order => 'position ASC'

  serialize :links, Array
  serialize :videos, Array

  validates_presence_of :parent_id

  def self.root
    self.where("parent_id=id").first
  end

  def self.home_page
    self.where(:name => "Home").first
  end

  def hierarchy_for_select(page = Page.root, tab = 0)
    select = [["#{'-' * 12 * tab}#{page.name}", page == self ? nil : page.id]]
    page.children.each do |child|
      select += self.hierarchy_for_select(child, tab + 1)
    end
    return select
  end

  def to_param
    "#{id}-#{name.gsub(' ', '-')}"
  end
end
