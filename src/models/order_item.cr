require "./order.cr"
require "./store.cr"
require "./good.cr"

class OrderItem < BaseModel
  table :order_items do
    belongs_to order : Order
    belongs_to from_store : Store?
    belongs_to good : Good?

    column price : Float64
    column weight_of_packaged_items : Float64
    column amount : Int8
  end
end
