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
      earned_query, used_query = 2.times do
        UserOrderQuery.new.created_at.asc_order
      end

      earned_query = earned_query.earned_bonuses.gt(0.to_i16)
      used_query = used_query.used_bonuses.gt(0.to_i16)

      w.each do |tuple|
        earned_query.where(tuple[0], tuple[1])
        used_query.where(tuple[0], tuple[1])
      end

      earned = earned_query.results
      used = used_query.results
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
#   u.bonuses, uo.used_bonuses, uo.earned_bonuses, uo.earned_bonuses_state
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
