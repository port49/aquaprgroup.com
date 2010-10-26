class Container < ActiveRecord::Base
  belongs_to :item, :polymorphic => true
  belongs_to :container, :polymorphic => true

end
