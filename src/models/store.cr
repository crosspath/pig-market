require "./address.cr"

class Store < BaseModel
  table do
    has_many order_items : OrderItem
    has_many goods_in_stores : GoodsInStore
    has_many goods : Good, through: [:goods_in_stores, :goods]
    has_many store_orders : StoreOrder
    has_many user_store_delivery_points : UserStoreDeliveryPoint

    belongs_to address : Address

    column type : Int16
    column name : String
    column address_notes : String
  end

  enum StoreType : Int16
    Shop
    Storehouse
  end
end
