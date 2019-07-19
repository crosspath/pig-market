require "./user.cr"
require "./address.cr"

class UserAddressDeliveryPoint < BaseModel
  table :user_address_delivery_points do
    # TODO: has_many_polymorphic user_orders : UserOrder, :delivery_point
    
    belongs_to user : User
    belongs_to address : Address

    column address_notes : String
    column hidden : Bool
    
    default({address_notes: "", hidden: false})
  end
end
