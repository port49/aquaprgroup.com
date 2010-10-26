require 'spec_helper'

describe PendingTest do
  before(:each) do
    @p = PendingTest.create(:name => "Something", :description => "About it.")
  end

  it "should create a record, and automagically be pending" do
    PendingTest.all.include?(@p).should be_true
    @p.is_pending?.should be_true
    @p.name.should == "Something"
    @p.load_pending
    @p.name.should == "Something"
  end

  it "should store pending values in the pending record" do
    @p.update_pending(:name => "Something else.")
    @p.name.should == "Something"
    @p.load_pending
    @p.name.should == "Something else."
  end

  # This test is to protect us from schema changes, where the pending attributes
  # don't match up with the current AR attributes.
  it "should silently drop a pending attribute that doesn't exist in the model" do
    @p.update_pending(:attr_doesnt_exist => "Something else.")
    lambda{@p.load_pending}.should_not raise_error
  end

  it "should revert from pending changes" do
    @p.update_pending(:name => "Something else.")
    @p.name.should == "Something"
    @p.load_pending
    @p.reset_pending
    @p.name.should == "Something"
  end

  it "should publish" do
    @p.update_pending(:name => "Something else.", :description => "Jake is wrong, as usual.")
    @p.publish!
    @p.is_published?.should be_true
    @p.name.should == "Something else."
    @p.description.should == "Jake is wrong, as usual."
  end
end
