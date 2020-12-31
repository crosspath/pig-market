require "./store.cr"
require "./good.cr"
require "./store_order.cr"
require "./user_order.cr"

class OrderItem < BaseModel
  table do
    belongs_to store : Store? # take Goods from this Store
    belongs_to good : Good?

    typical_polymorphic order : StoreOrder | UserOrder
    # column order_type : String
    # column order_id : Int32

    column price : Float64
    column weight_of_packaged_items : Float64
    column amount : Int16
  end
end
