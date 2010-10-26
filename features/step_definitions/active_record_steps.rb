# Helper steps for generic resources.
#
Given /^I have no (.+)$/ do |model|
  model.gsub(' ', '_').classify.constantize.delete_all
end

Then /^I should have ([0-9]+) (.+)$/ do |count, model|
  model.gsub(' ', '_').classify.constantize.all.length.should == count.to_i
end

Then /^I should have ([0-9]+) (.+) for (\w+) \"?([^\"]+)\"?$/ do |count, model, parent_model, parent_name|
  parent_conditions = {:name => parent_name}
  parent = parent_model.gsub(' ', '_').classify.constantize.first(:conditions => parent_conditions)
  parent.send(model.gsub(' ', '_').classify.tableize.to_sym).count.should == count.to_i
end
