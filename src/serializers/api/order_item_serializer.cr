class Api::OrderItemSerializer < BaseSerializer
  def initialize(
    @item : OrderItem,
    @good : Good | Nil = nil,
    @store : Store | Nil = nil,
    @order : StoreOrder | UserOrder | Nil = nil
  ); end

  def render
    res = Hash(Symbol, ResultValue){
      :id => @item.id,
      :price => @item.price,
      :amount => @item.amount,
      :weight_of_packaged_items => @item.weight_of_packaged_items
    }

    if @good
      res[:good] = Api::GoodSerializer.new(@good.not_nil!)
    end

    if @store
      res[:store] = Api::StoreSerializer.new(@store.not_nil!)
    end

    case @order
    when StoreOrder
      res[:store_order] = Api::StoreOrderSerializer.new(@order.as(StoreOrder))
    when UserOrder
      res[:user_order] = Api::UserOrderSerializer.new(@order.as(UserOrder))
    end

    res
  end
end
