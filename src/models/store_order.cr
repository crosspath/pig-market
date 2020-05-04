require "./store.cr"
require "./user.cr"

class StoreOrder < BaseModel
  table do
    # TODO: has_many_polymorphic order_items : OrderItem, :order

    belongs_to store : Store
    belongs_to user : User

    column planned_delivery_date : Time? # Only date
    column delivered_at : Time?
    column total_cost : Float64
    column total_weight : Float64
  end
end
