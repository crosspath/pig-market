class Api::UserOrders::Index < ApiAction
  get "/api/user_orders" do
    orders = UserOrderQuery.new.created_at.asc_order

    result = Api::UserOrderSerializer.for_collection(orders)

    response_success(orders: result)
  rescue e
    response_error(500, e)
  end
end
