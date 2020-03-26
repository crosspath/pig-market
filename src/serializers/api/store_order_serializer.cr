class Api::StoreOrderSerializer < BaseSerializer
  def initialize(
    @order : StoreOrder,
    @user : User | Nil = nil,
    @store : Store | Nil = nil,
    @items : Array(OrderItem) | OrderItemQuery | Nil = nil
  ); end

  def render
    res = Hash(Symbol, ResultValue){
      :id => @order.id,
      :planned_delivery_date => @order.planned_delivery_date.try { |v| v.to_s("%F") }, # Y-m-d
      :delivered_at => @order.delivered_at.try { |v| v.to_s("%F %T") }, # Y-m-d H:M:S
      :total_cost => @order.total_cost,
      :total_weight => @order.total_weight
    }

    if @user
      res[:user] = Api::UserSerializer.new(@user.not_nil!)
    end

    if @store
      res[:store] = Api::StoreSerializer.new(@store.not_nil!)
    end

    if @items
      items = Api::OrderItemSerializer.for_collection(@items.not_nil!)
      res[:order_items] = items
    end

    res
  end
end
