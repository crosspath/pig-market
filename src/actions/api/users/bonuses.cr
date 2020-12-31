class Api::Users::Bonuses < ApiAction
  get "/api/users/:user_id/bonuses" do
    address_dp = UserAddressDeliveryPointQuery.new.for_user(user_id)
    store_dp = UserStoreDeliveryPointQuery.new.for_user(user_id)

    earned = [] of UserOrder
    used   = [] of UserOrder
    if !address_dp.empty? || !store_dp.empty?
      earned_query = UserOrderQuery.new.created_at.asc_order.earned_bonuses.gt(0.to_i16)
      used_query   = UserOrderQuery.new.created_at.asc_order.used_bonuses.gt(0.to_i16)

      earned_query = earned_query.delivery_point(address: address_dp, store: store_dp)
      used_query   = used_query.delivery_point(address: address_dp, store: store_dp)

      earned = earned_query.results
      used   = used_query.results
    end

    user = UserQuery.find(user_id)
    amount = user.bonuses

    result = SpecialApi::UserBonusesSerializer.new(amount, earned, used)

    response_success(bonuses: result)
  rescue e
    response_error(500, e)
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
