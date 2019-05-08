class Api::Orders::Index < ApiAction
  route do
    orders = OrderQuery.new.created_at.asc_order.preload_address

    result = Api::OrdersSerializer.new(orders, addresses: true)

    response_success(orders: result)
  rescue e
    response_error(500, e)
  end
end
