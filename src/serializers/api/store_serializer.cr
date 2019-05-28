class Api::StoreSerializer < Lucky::Serializer
  alias InStoresValue = GoodsInStore | Good | Store | Nil
  alias ResultValue = Int16 | Int32 | String | Nil | Lucky::Serializer |
    Array(Api::UserStoreDeliveryPointSerializer)

  def initialize(
    @store : Store,
    @address : Address | Nil = nil,
    @in_stores : Array(Hash(String, InStoresValue)) | Nil = nil,
    @order_items : Array(OrderItem) | OrderItemQuery | Nil = nil,
    @store_orders : Array(StoreOrder) | StoreOrderQuery | Nil = nil,
    @delivery_points : Array(UserStoreDeliveryPoint) | UserStoreDeliveryPointQuery | Nil = nil
  ); end

  def render
    res = Hash(Symbol, ResultValue){
      :id => @store.id,
      :type => @store.type,
      :type_name => Store::StoreType.from_value?(@store.type).try(&.to_s),
      :name => @store.name,
      :address_notes => @store.address_notes
    }

    if @address
      res[:address] = Api::AddressSerializer.new(@address.not_nil!)
    end
    
    if @in_stores
      res[:in_stores] = Api::GoodsInStoresSerializer.new(@in_stores.not_nil!)
    end

    if @order_items
      res[:order_items] = Api::OrderItemsSerializer.new(@order_items.not_nil!)
    end

    if @store_orders
      res[:store_orders] = Api::StoreOrdersSerializer.new(@store_orders.not_nil!)
    end

    if @delivery_points
      res[:user_store_delivery_points] = @delivery_points.not_nil!.map do |u|
        Api::UserStoreDeliveryPointSerializer.new(u)
      end
    end

    res
  end
end
