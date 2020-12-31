class Api::Users::UserOrders < ApiAction
  get "/api/users/:user_id/user_orders" do
    address_dp = UserAddressDeliveryPointQuery.new.for_user(user_id)
    store_dp = UserStoreDeliveryPointQuery.new.for_user(user_id)

    orders = [] of UserOrder
    if !address_dp.empty? || !store_dp.empty?
      orders_query = UserOrderQuery.new.created_at.asc_order
      orders_query = orders_query.delivery_point(address: address_dp, store: store_dp)

      orders = orders_query.results
    end

    result = Api::UserOrderSerializer.for_collection(orders)

    response_success(user_orders: result)
  rescue e
    response_error(500, e)
  end
end
