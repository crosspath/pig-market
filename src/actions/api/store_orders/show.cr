class Api::StoreOrders::Show < ApiAction
  route do
    order = StoreOrderQuery.new.preload_user.preload_store.find(order_id)
    items = OrderItemQuery.new.order_type(StoreOrder.name).order_id(order.id).results

    result = Api::StoreOrderSerializer.new(order, order.user, order.store, items)

    response_success(order: result)
  rescue e
    response_error(500, e)
  end
end
