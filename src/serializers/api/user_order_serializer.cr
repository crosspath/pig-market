class Api::UserOrderSerializer < Lucky::Serializer
  def initialize(
    @order : UserOrder,
    @with_items : Bool = true,
    @with_bonus : Bool = true,
    @with_delivery_point : Bool = true
  ); end

  def render
    res = {
      id: @order.id,
      planned_delivery_date: @order.planned_delivery_date,
      planned_delivery_time_interval: @order.planned_delivery_time_interval,
      delivered_at: @order.delivered_at,
      total_cost: @order.total_cost,
      total_weight: @order.total_weight,
      used_bonuses: @order.used_bonuses
    }
    if @with_delivery_point
      dp = @order.delivery_point
      res[:delivery_point] = case @order.delivery_point_type
      when "UserAddressDeliveryPoint"
        Api::UserAddressDeliveryPointSerializer.new(dp, with_order: false, with_address: true)
      when "UserAddressDeliveryPoint"
        Api::UserStoreDeliveryPointSerializer.new(dp, with_order: false, with_store: true)
      else
        nil
      end
    end
    if @with_bonus
      bonus = @order.bonus_change
      res[:earned_bonuses] = {
        change: bonus.change,
        state: bonus.state
      }
    end
    if @with_items
      raise "Not implemented" # TODO
    end

    res
  end
end
