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

root = Page.root
create_page("root", root)
create_page("Home Page", root)
create_page("Feedback", root)
create_page("Image Use Policy", root)
create_page("Privacy Policy", root)
create_page("News", root)
create_page("Gallery", root)

