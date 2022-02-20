class Api::StoreOrders::Index < ApiAction
  get "/api/store_orders" do
    orders = StoreOrderQuery.new.created_at.asc_order

    result = Api::StoreOrderSerializer.for_collection(orders)

    response_success(orders: result)
  rescue e
    response_error(500, e)
  end
end
