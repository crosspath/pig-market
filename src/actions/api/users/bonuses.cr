class Api::Users::Bonuses < ApiAction
  get "/api/users/:user_id/bonuses" do
    address_dp = UserAddressDeliveryPointQuery.new.user_id(user_id).results.map(&.id).to_a
    store_dp = UserStoreDeliveryPointQuery.new.user_id(user_id).results.map(&.id).to_a

    w = [] of Tuple(String, Array(Int32))
    add_sql_where_delivery_point(w, UserAddressDeliveryPoint.name, address_dp)
    add_sql_where_delivery_point(w, UserStoreDeliveryPoint.name, store_dp)

    if w.empty?
      earned = [] of UserOrder
      used   = [] of UserOrder
    else
      where_clause = w.map(&.first).join(" OR ")
      where_values = w.flat_map(&.last)

      earned_query = UserOrderQuery.new.created_at.asc_order.earned_bonuses.gt(0.to_i16)
      used_query   = UserOrderQuery.new.created_at.asc_order.used_bonuses.gt(0.to_i16)

      earned = earned_query.where_in(where_clause, where_values).results
      used = used_query.where_in(where_clause, where_values).results
    end

    user = UserQuery.find(user_id)
    amount = user.bonuses

    result = SpecialApi::UserBonusesSerializer.new(amount, earned, used)

    response_success(bonuses: result)
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

# Проверить, могут ли пользователи использовать бонусы до их начисления:
#
# select u.id as user_id, uo.id as order_id,
#   u.bonuses, uo.used_bonuses, uo.earned_bonuses, uo.earned_bonuses_state as state
# from users as u
#   left join user_address_delivery_points as ad on u.id = ad.user_id
#   left join user_store_delivery_points as sd on u.id = sd.user_id
#   left join user_orders as uo on (
#     uo.delivery_point_type = 'UserAddressDeliveryPoint' and uo.delivery_point_id = ad.id
#   ) or (
#     uo.delivery_point_type = 'UserStoreDeliveryPoint' and uo.delivery_point_id = sd.id
#   )
# where uo.id is not null
# order by u.id, uo.id;
