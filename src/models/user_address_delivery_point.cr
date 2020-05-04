require "./user.cr"
require "./address.cr"

class UserAddressDeliveryPoint < BaseModel
  table do
    # TODO: has_many_polymorphic user_orders : UserOrder, :delivery_point

    belongs_to user : User
    belongs_to address : Address

    column address_notes : String
    column hidden : Bool
  end

  macro add_default_columns
    column address_notes : String
    column hidden : Bool
  end
end
