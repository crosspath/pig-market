class Api::UserOrders::Show < ApiAction
  route do
    order = UserOrderQuery.new.find(order_id)
    delivery_point = order.delivery_point
    items = OrderItemQuery.new.order_type(UserOrder.name).order_id(order.id).results

    result = Api::UserOrderSerializer.new(order, delivery_point, items)

    response_success(order: result)
  rescue e
    response_error(500, e)
  end
end
