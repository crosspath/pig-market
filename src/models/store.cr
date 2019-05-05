class Store < BaseModel
  table :stores do
    has_many order_items : OrderItem
    has_many goods_in_stores : GoodsInStore
    
    column type : Int16
    column name : String

    default({:type => 0}) # Shop
  end
  
  enum StoreType : Int16
    Shop
    Storehouse
  end

  # polymorphic
  def addresses
    
  end
end
