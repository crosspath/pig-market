require "./user.cr"
require "./store.cr"

class UserStoreDeliveryPoint < BaseModel
  table :user_store_delivery_points do
    # TODO: has_many_polymorphic user_orders : UserOrder, :delivery_point
    
    belongs_to user : User
    belongs_to store : Store

    column hidden : Bool
    
    default({:hidden => false})
  end
end
