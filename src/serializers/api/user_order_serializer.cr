class Api::UserOrderSerializer < BaseSerializer
  alias AddressPointSerializer = Api::UserAddressDeliveryPointSerializer
  alias StorePointSerializer = Api::UserStoreDeliveryPointSerializer

  def initialize(
    @order : UserOrder,
    @delivery_point : UserAddressDeliveryPoint | UserStoreDeliveryPoint | Nil = nil,
    @items : Array(OrderItem) | OrderItemQuery | Nil = nil
  ); end

  def render
    time_interval = @order.planned_delivery_time_interval
    time_interval_name = time_interval && UserOrder::DeliveryTime.from_value?(time_interval)

    bonuses_state = @order.earned_bonuses_state
    bonuses_state_name = UserOrder::EarnedBonusesState.from_value?(bonuses_state)

    res = Hash(Symbol, ResultValue){
      :id => @order.id,
      :planned_delivery_date => @order.planned_delivery_date.try { |v| v.to_s("%F") }, # Y-m-d
      :planned_delivery_time_interval => time_interval,
      :planned_delivery_time_interval_name => time_interval_name.try(&.to_s),
      :delivered_at => @order.delivered_at.try { |v| v.to_s("%F %T") }, # Y-m-d H:M:S
      :total_cost => @order.total_cost,
      :total_weight => @order.total_weight,
      :used_bonuses => @order.used_bonuses,
      :earned_bonuses => @order.earned_bonuses,
      :earned_bonuses_state => bonuses_state,
      :earned_bonuses_state_name => bonuses_state_name.try(&.to_s)
    }

    case @delivery_point
    when UserAddressDeliveryPoint
      dp = @delivery_point.as(UserAddressDeliveryPoint)
      res[:user_address_delivery_point] = AddressPointSerializer.new(dp)
    when UserStoreDeliveryPoint
      dp = @delivery_point.as(UserStoreDeliveryPoint)
      res[:user_store_delivery_point] = StorePointSerializer.new(dp)
    else
      nil
    end

    if @items
      items = Api::OrderItemSerializer.for_collection(@items.not_nil!)
      res[:order_items] = items
    end

    res
  end
end
