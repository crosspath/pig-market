require "./address.cr"

class Store < BaseModel
  table :stores do
    has_many order_items : OrderItem
    has_many goods_in_stores : GoodsInStore
    has_many goods : Good, :goods_in_stores
    has_many store_orders : StoreOrder
    has_many user_store_delivery_points : UserStoreDeliveryPoint
    
    belongs_to address : Address
    
    column type : Int16
    column name : String
    column address_notes : String

    default({type: 0.to_i16}) # Shop
  end
  
  enum StoreType : Int16
    Shop
    Storehouse
  end
end
