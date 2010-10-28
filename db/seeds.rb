# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# Page.destroy_all
def create_page(name, parent)
  unless page = Page.find_by_name_and_parent_id(name, parent.id)
    Page.create(:name => name, :parent_id => parent.id)
  else
    puts page.inspect
  end
end

p = Page.create(:name => 'root', :parent_id => 1)

root = Page.root
create_page("root", root)
create_page("Home Page", root)

