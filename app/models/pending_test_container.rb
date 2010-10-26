class PendingTestContainer < ActiveRecord::Base
  include Pendable
  include Containable
  
  contains :pending_tests
end
