require "./address.cr"

class Store < BaseModel
  table :stores do
    has_many items : OrderItem
    has_many stored_goods : GoodsInStore
    
    belongs_to address : Address

    column type : Int32
    column name : String
  end
end
