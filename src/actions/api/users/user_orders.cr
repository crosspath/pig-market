class Api::Users::UserOrders < ApiAction
  get "/api/users/:user_id/user_orders" do
    address_dp = UserAddressDeliveryPointQuery.new.user_id(user_id).results.map(&.id).to_a
    store_dp = UserStoreDeliveryPointQuery.new.user_id(user_id).results.map(&.id).to_a

    w = [] of Tuple(String, Array(Int32))
    add_sql_where_delivery_point(w, "UserAddressDeliveryPoint", address_dp)
    add_sql_where_delivery_point(w, "UserStoreDeliveryPoint", store_dp)

    if w.empty?
      orders = [] of UserOrder
    else
      orders_query = UserOrderQuery.new.created_at.asc_order

      w.each do |tuple|
        orders_query.where(tuple[0], tuple[1])
      end

      orders = orders_query.preload_user_orders.results
    end

    result = Api::UserOrdersSerializer.new(orders)

    response_success(user_orders: result)
  rescue e
    response_error(500, e)
  end

  private def add_sql_where_delivery_point(
    list : Array(Tuple(String, Array(Int32))),
    class_name : String,
    ids : Array(Int32)
  )
    unless ids.empty?
      list << {"(delivery_point_type = '#{class_name}' and delivery_point_id in (?" + ",?" * (ids.size - 1) + "))", ids}
    end
  end
end
