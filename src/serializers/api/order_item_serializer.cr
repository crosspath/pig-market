class Api::OrderItemSerializer < Lucky::Serializer
  alias ResultValue = Int16 | Int32 | Float | Api::GoodSerializer | Api::StoreSerializer
    | Api::StoreOrderSerializer | Api::UserOrderSerializer

  def initialize(
    @item : OrderItem,
    @good : Good | Nil = nil,
    @store : Store | Nil = nil,
    @order : StoreOrder | UserOrder | Nil = nil
  ); end

  def render
    res = Hash(Symbol, ResultValue){
      id: @item.id,
      price: @item.price,
      amount: @item.amount,
      weight_of_packaged_items: @item.weight_of_packaged_items
    }

    if @good
      res[:good] = Api::GoodSerializer.new(@good)
    end

    if @store
      res[:store] = Api::StoreSerializer.new(@store)
    end

    case @order
    when StoreOrder
      res[:store_order] = Api::StoreOrderSerializer.new(@order)
    when UserStoreDeliveryPoint
      res[:user_order] = Api::UserOrderSerializer.new(@order)
    end

    res
  end
end
