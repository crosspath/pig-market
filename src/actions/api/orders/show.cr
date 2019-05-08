class Api::Orders::Show < ApiAction
  route do
    order = OrderQuery.new.preload_address.preload_order_items.find(order_id)

    result = Api::OrderSerializer.new(order, addresses: true, items: true)

    response_success(order: result)
  rescue e
    response_error(500, e)
  end
end
