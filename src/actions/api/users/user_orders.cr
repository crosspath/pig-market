class Api::Users::UserOrders < ApiAction
  get "/api/users/:user_id/user_orders" do
    address_dp = UserAddressDeliveryPointQuery.new.user_id(user_id).results.map(&.id).to_a
    store_dp = UserStoreDeliveryPointQuery.new.user_id(user_id).results.map(&.id).to_a

    w = [] of Tuple(String, Array(Int32))
    add_sql_where_delivery_point(w, UserAddressDeliveryPoint.name, address_dp)
    add_sql_where_delivery_point(w, UserStoreDeliveryPoint.name, store_dp)

    if w.empty?
      orders = [] of UserOrder
    else
      where_clause = w.map(&.first).join(" OR ")
      where_values = w.flat_map(&.last)

      orders_query = UserOrderQuery.new.created_at.asc_order

      orders = orders_query.where_in(where_clause, where_values).results
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
      q = "?" + ",?" * (ids.size - 1)
      list << {"(delivery_point_type = '#{class_name}' and delivery_point_id in (" + q + "))", ids}
    end
  end
end
