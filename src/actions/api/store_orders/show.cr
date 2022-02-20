class Api::StoreOrders::Show < ApiAction
  get "/api/store_orders/:store_order_id" do
    order = StoreOrderQuery.new.preload_user.preload_store.find(store_order_id)
    items = OrderItemQuery.new.order_type(StoreOrder.name).order_id(store_order_id).results

    result = Api::StoreOrderSerializer.new(order, order.user, order.store, items)

    response_success(order: result)
  rescue e
    response_error(500, e)
  end
end
