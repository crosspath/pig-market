require "./store.cr"
require "./good.cr"

class OrderItem < BaseModel
  table :order_items do
    belongs_to store : Store? # take Goods from this Store
    belongs_to good : Good?

    # TODO: polymorphic order : StoreOrder | UserOrder
    column order_type : String
    column order_id : Int32
    column price : Float64
    column weight_of_packaged_items : Float64
    column amount : Int16

    default({:amount => 1})
  end
end
