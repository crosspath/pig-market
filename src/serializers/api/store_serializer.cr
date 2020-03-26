class Api::StoreSerializer < BaseSerializer
  alias InStoresValue = GoodsInStore | Good | Store | Nil

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
      items = Api::GoodsInStoreSerializer.for_collection(@in_stores.not_nil!)
      res[:in_stores] = items
    end

    if @order_items
      items = Api::OrderItemSerializer.for_collection(@order_items.not_nil!)
      res[:order_items] = items
    end

    if @store_orders
      items = Api::StoreOrderSerializer.for_collection(@store_orders.not_nil!)
      res[:store_orders] = items
    end

    if @delivery_points
      res[:user_store_delivery_points] = @delivery_points.not_nil!.map do |u|
        Api::UserStoreDeliveryPointSerializer.new(u).as(Lucky::Serializer)
      end
    end

    res
  end
end
