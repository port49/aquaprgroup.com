require 'spec_helper'

describe Container do
  before(:each) do
    @p1 = PendingTest.create(:name => "Something", :description => "About it.")
    @p2 = PendingTest.create(:name => "Something Else", :description => "About not it.")
    @p3 = PendingTest.create(:name => "Something Else Entirely", :description => "About... I forget.")
    @c1 = PendingTestContainer.create(:name => "Place")
    @c2 = PendingTestContainer.create(:name => "Other Place")
    @c3 = PendingTestContainer.create(:name => "Place Other than Place")
  end

  it "should have empty associations of each other" do
    @p1.pending_test_containers.should be_empty
    @c1.pending_tests.should be_empty
  end

  it "should be able to add one item to container as pending containment" do
    @c1.pending_tests.should be_empty
    @c1.append_pending_pending_test @p1
    # relationship is pending
    @c1.pending_pending_tests.include?(@p1).should be_true
    @c1.pending_pending_tests.length.should == 1
    @p1.pending_pending_test_containers.include?(@c1).should be_true
    @p1.pending_pending_test_containers.length.should == 1
    # relationship is not yet published
    @c1.pending_tests.include?(@p1).should_not be_true
    @c1.pending_tests.should be_empty
    @p1.pending_test_containers.include?(@c1).should_not be_true
    @p1.pending_test_containers.should be_empty
  end

  it "should be able to add one container for item as pending containment" do
    @p1.pending_test_containers.should be_empty
    @p1.append_pending_pending_test_container @c1
    # relation is pending
    @p1.pending_pending_test_containers.include?(@c1).should be_true
    @p1.pending_pending_test_containers.length.should == 1
    @c1.pending_pending_tests.include?(@p1).should be_true
    @c1.pending_pending_tests.length.should == 1
    #relation is not yet published
    @p1.pending_test_containers.include?(@c1).should_not be_true
    @p1.pending_test_containers.should be_empty
    @c1.pending_tests.include?(@p1).should_not be_true
    @c1.pending_tests.should be_empty
  end

  it "should be able to remove_all_pending items from a container" do
    @c1.pending_pending_tests.should be_empty
    @c1.append_pending_pending_test @p1
    @c1.append_pending_pending_test @p2
    @c1.pending_pending_tests.length.should == 2
    @c1.remove_all_pending_pending_tests
    @c1.pending_pending_tests.should be_empty
  end

  it "should be able to remove_all_pending containers from an item" do
    @p1.pending_pending_test_containers.should be_empty
    @p1.append_pending_pending_test_container @c1
    @p1.append_pending_pending_test_container @c2
    @p1.pending_pending_test_containers.length.should == 2
    @p1.remove_all_pending_pending_test_containers
    @p1.pending_pending_test_containers.should be_empty
  end

  it "should be able to bulk set pending items to container" do
    @c1.pending_pending_tests.should be_empty
    @c1.set_pending_pending_tests [@p1, @p3]
    @c1.pending_pending_tests.include?(@p1).should be_true
    @c1.pending_pending_tests.include?(@p2).should_not be_true
    @c1.pending_pending_tests.include?(@p3).should be_true
    @c1.pending_pending_tests.length.should == 2
    @p1.pending_pending_test_containers.include?(@c1).should be_true
    @p2.pending_pending_test_containers.include?(@c1).should_not be_true
    @p3.pending_pending_test_containers.include?(@c1).should be_true
    @p1.pending_pending_test_containers.length.should == 1
    @p2.pending_pending_test_containers.should be_empty
    @p3.pending_pending_test_containers.length.should == 1
  end

  it "should be able to bulk set pending containers for item" do
    @p1.pending_pending_test_containers.should be_empty
    @p1.set_pending_pending_test_containers [@c1, @c3]
    @p1.pending_pending_test_containers.include?(@c1).should be_true
    @p1.pending_pending_test_containers.include?(@c2).should_not be_true
    @p1.pending_pending_test_containers.include?(@c3).should be_true
    @p1.pending_pending_test_containers.length.should == 2
    @c1.pending_pending_tests.include?(@p1).should be_true
    @c2.pending_pending_tests.include?(@p1).should_not be_true
    @c3.pending_pending_tests.include?(@p1).should be_true
    @c1.pending_pending_tests.length.should == 1
    @c2.pending_pending_tests.should be_empty
    @c3.pending_pending_tests.length.should == 1
  end

  it "should be able to publish pending items to container" do
    # everything is empty
    @c1.pending_tests.should be_empty
    @c1.pending_pending_tests.should be_empty
    @c1.set_pending_pending_tests [@p1, @p3]
    # pending is set, published is empty
    @c1.pending_tests.should be_empty
    @c1.pending_pending_tests.length.should == 2
    @c1.publish_pending_tests!
    # now published is in sync with pending
    @c1.pending_tests.length.should == 2
    @c1.pending_pending_tests.length.should == 2
    @p1.pending_test_containers.include?(@c1).should be_true
    @p2.pending_test_containers.include?(@c1).should_not be_true
    @p3.pending_test_containers.include?(@c1).should be_true
    @p1.pending_pending_test_containers.include?(@c1).should be_true
    @p2.pending_pending_test_containers.include?(@c1).should_not be_true
    @p3.pending_pending_test_containers.include?(@c1).should be_true
  end

  it "should be able to publish pending container for items" do
    # everything is empty
    @p1.pending_test_containers.should be_empty
    @p1.pending_pending_test_containers.should be_empty
    @p1.set_pending_pending_test_containers [@c1, @c3]
    # pending is set, published is empty
    @p1.pending_test_containers.should be_empty
    @p1.pending_pending_test_containers.length.should == 2
    @p1.publish_pending_test_containers!
    # now published is in sync with pending
    @p1.pending_test_containers.length.should == 2
    @p1.pending_pending_test_containers.length.should == 2
    @c1.pending_tests.include?(@p1).should be_true
    @c2.pending_tests.include?(@p1).should_not be_true
    @c3.pending_tests.include?(@p1).should be_true
    @c1.pending_pending_tests.include?(@p1).should be_true
    @c2.pending_pending_tests.include?(@p1).should_not be_true
    @c3.pending_pending_tests.include?(@p1).should be_true
  end

  it "should publish pending items to container when the item is published" do
    # everything is empty
    @c1.pending_tests.should be_empty
    @c1.pending_pending_tests.should be_empty
    @c1.set_pending_pending_tests [@p1, @p3]
    # pending is set, published is empty
    @c1.pending_tests.should be_empty
    @c1.pending_pending_tests.length.should == 2
    @c1.publish!
    # now published is in sync with pending
    @c1.pending_tests.length.should == 2
    @c1.pending_pending_tests.length.should == 2
    @p1.pending_test_containers.include?(@c1).should be_true
    @p2.pending_test_containers.include?(@c1).should_not be_true
    @p3.pending_test_containers.include?(@c1).should be_true
    @p1.pending_pending_test_containers.include?(@c1).should be_true
    @p2.pending_pending_test_containers.include?(@c1).should_not be_true
    @p3.pending_pending_test_containers.include?(@c1).should be_true
  end

  it "should publish pending container for items when the container is published" do
    # everything is empty
    @p1.pending_test_containers.should be_empty
    @p1.pending_pending_test_containers.should be_empty
    @p1.set_pending_pending_test_containers [@c1, @c3]
    # pending is set, published is empty
    @p1.pending_test_containers.should be_empty
    @p1.pending_pending_test_containers.length.should == 2
    @p1.publish!
    # now published is in sync with pending
    @p1.pending_test_containers.length.should == 2
    @p1.pending_pending_test_containers.length.should == 2
    @c1.pending_tests.include?(@p1).should be_true
    @c2.pending_tests.include?(@p1).should_not be_true
    @c3.pending_tests.include?(@p1).should be_true
    @c1.pending_pending_tests.include?(@p1).should be_true
    @c2.pending_pending_tests.include?(@p1).should_not be_true
    @c3.pending_pending_tests.include?(@p1).should be_true
  end
end
