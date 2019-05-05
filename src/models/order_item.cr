require "./order.cr"
require "./store.cr"
require "./good.cr"

class OrderItem < BaseModel
  table :order_items do
    belongs_to order : Order
    belongs_to store : Store? # take Goods from this Store
    belongs_to good : Good?

    column price : Float64
    column weight_of_packaged_items : Float64
    column amount : Int16

    default({:amount => 1})
  end
end
