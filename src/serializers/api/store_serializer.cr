class Api::StoreSerializer < Lucky::Serializer
  alias ResultValue = Int16 | Int32 | String | Api::AddressSerializer
    | Api::GoodsInStoresSerializer | Api::OrderItemsSerializer | Api::StoreOrdersSerializer
    | Array(Api::UserStoreDeliveryPointSerializer)

  def initialize(
    @store : Store,
    @address : Address | Nil = nil,
    @in_stores : Array(Tuple(GoodsInStore, Good?, Store?)) | Nil = nil,
    @order_items : Array(OrderItem) | OrderItemQuery | Nil = nil,
    @store_orders : Array(StoreOrder) | StoreOrderQuery | Nil = nil,
    @delivery_points : Array(UserStoreDeliveryPoint) | UserStoreDeliveryPointQuery | Nil = nil
  ); end

  def render
    res = Hash(Symbol, ResultValue){
      id: @store.id,
      type: @store.type,
      type_name: Store::StoreType.from_value?(@store.type),
      name: @store.name
      address_notes: @store.address_notes
    }

    if @address
      res[:address] = Api::AddressSerializer.new(@address)
    end
    
    if @in_stores
      res[:in_stores] = Api::GoodsInStoresSerializer.new(@in_stores)
    end

    if @order_items
      res[:order_items] = Api::OrderItemsSerializer.new(@order_items)
    end

    if @store_orders
      res[:store_orders] = Api::StoreOrdersSerializer.new(@store_orders)
    end

    if @delivery_points
      res[:user_store_delivery_points] = @delivery_points.map do |u|
        Api::UserStoreDeliveryPointSerializer.new(u)
      end
    end

    res
  end
end
