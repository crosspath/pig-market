require "./address.cr"

class Store < BaseModel
  table :stores do
    has_many items : OrderItem
    has_many goods_in_stores : GoodsInStore
    
    belongs_to address : Address

    column type : Int16
    column name : String
  end
  
  enum StoreType : Int16
    Shop
    Storehouse
  end
end
