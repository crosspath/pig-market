class Api::StoreOrderSerializer < Lucky::Serializer
  alias ResultValue = Int32 | String | Float | Nil | Api::UserSerializer | Api::StoreSerializer
    | Array(Api::OrderItemSerializer)

  def initialize(
    @order : StoreOrder,
    @user : User | Nil = nil,
    @store : Store | Nil = nil,
    @items : Array(OrderItem) | OrderItemQuery | Nil = nil
  ); end

  def render
    res = Hash(Symbol, ResultValue){
      id: @order.id,
      planned_delivery_date: @order.planned_delivery_date.try { |v| v.to_s("%F") }, # Y-m-d
      delivered_at: @order.delivered_at.try { |v| v.to_s("%F %T") }, # Y-m-d H:M:S
      total_cost: @order.total_cost,
      total_weight: @order.total_weight
    }

    if @user
      res[:user] = Api::UserSerializer.new(@user)
    end

    if @store
      res[:store] = Api::StoreSerializer.new(@store)
    end

    if @items
      res[:order_items] = @items.map do |u|
        Api::OrderItemSerializer.new(u)
      end
    end

    res
  end
end
