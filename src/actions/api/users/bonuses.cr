class Api::Users::Bonuses < ApiAction
  get "/api/users/:user_id/bonuses" do
    address_dp = UserAddressDeliveryPointQuery.new.user_id(user_id).results.map(&.id).to_a
    store_dp = UserStoreDeliveryPointQuery.new.user_id(user_id).results.map(&.id).to_a

    w = [] of Tuple(String, Array(Int32))
    add_sql_where_delivery_point(w, "UserAddressDeliveryPoint", address_dp)
    add_sql_where_delivery_point(w, "UserStoreDeliveryPoint", store_dp)

    if w.empty?
      bc_earned = [] of BonusChange
      # {user_orders.id, user_orders.used_bonuses, user_orders.created_at}
      bc_used   = [] of Tuple(Int32, Int16, Time)
    else
      join = Avram::Join::Right.new(BonusChange::TABLE_NAME, UserOrder::TABLE_NAME)
      bc_query = BonusChangeQuery.new.join(join).created_at.asc_order
      uo_query = UserOrderQuery.new.used_bonuses.gt(0.to_i16).created_at.asc_order

      w.each do |tuple|
        bc_query.where(tuple[0], tuple[1])
        uo_query.where(tuple[0], tuple[1])
      end

      bc_earned = bc_query.preload_user_orders.results
      bc_used   = uo_query.results.map { |x| {x.id, x.used_bonuses, x.created_at} }.to_a
    end

    user = UserQuery.find(user_id)
    amount = user.bonuses

    result = Api::UserBonusesSerializer.new(amount, bc_earned, bc_used)

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
# select u.id as user_id, uo.id as order_id, bonuses, used_bonuses, change, state
# from users as u
#   left join user_address_delivery_points as ad on u.id = ad.user_id
#   left join user_store_delivery_points as sd on u.id = sd.user_id
#   left join user_orders as uo on (
#     uo.delivery_point_type = 'UserAddressDeliveryPoint' and uo.delivery_point_id = ad.id
#   ) or (
#     uo.delivery_point_type = 'UserStoreDeliveryPoint' and uo.delivery_point_id = sd.id
#   ) left join bonus_changes as bc on bc.id = uo.bonus_change_id
# where uo.id is not null
# order by u.id, uo.id;
