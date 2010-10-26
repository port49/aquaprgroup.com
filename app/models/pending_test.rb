class PendingTest < ActiveRecord::Base
  include Pendable
  include Containable
  
  contained_by :pending_test_containers
end
