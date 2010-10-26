class Pending < ActiveRecord::Base
  serialize :serialized_attributes, Hash
end
