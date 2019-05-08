class Api::OrderSerializer < Lucky::Serializer
  def initialize(@order : Order, @addresses : Bool = false, @items : Bool = false); end

  def render
    attributes = {
      id: @order.id,
      address_id: @order.address_id,
      planned_delivery_date: @order.planned_delivery_date,
      delivered_at: @order.delivered_at,
      total_cost: @order.total_cost,
      total_weight: @order.total_weight,
      planned_delivery_time_interval: @order.planned_delivery_time_interval,
    }

    if @addresses
      attributes = attributes.merge({
        addresses: Api::AddressSerializer.new(@order.address)
      })
    end

    if @items
      attributes = attributes.merge({
        items: @order.order_items.map do |a|
          {
            id: a.id,
            store_id: a.store_id,
            good_id: a.good_id,
            price: a.price,
            amount: a.amount,
            weight_of_packaged_items: a.weight_of_packaged_items
          }
        end
      })
    end

    attributes
  end
end
