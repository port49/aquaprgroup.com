Given /^the following widgets:$/ do |resources|
  Widget.create!(resources.hashes)
end

Then /^I should see the following widgets:$/ do |expected_widgets_table|
  expected_widgets_table.diff!(tableish('table tr', 'td,th'))
end

Then /^widget "([^\"]*)" should be published$/ do |resource|
  Widget.where(:name => resource).should be_published
end
