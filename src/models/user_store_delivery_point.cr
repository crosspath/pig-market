require "./user.cr"
require "./store.cr"

class UserStoreDeliveryPoint < BaseModel
  table do
    # TODO: has_many_polymorphic user_orders : UserOrder, :delivery_point

    belongs_to user : User
    belongs_to store : Store

    column hidden : Bool
  end

  macro add_default_columns
    column hidden : Bool
  end
end
