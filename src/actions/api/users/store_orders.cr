class Api::Users::StoreOrders < ApiAction
  get "/api/users/:user_id/store_orders" do
    orders = StoreOrderQuery.new.user_id(user_id).created_at.asc_order

    result = Api::StoreOrdersSerializer.new(orders)

    response_success(store_orders: result)
  rescue e
    response_error(500, e)
  end
end
