class Api::Users::DeliveryPoints < ApiAction
  get "/api/users/:user_id/delivery_points" do
    address_dp = UserAddressDeliveryPointQuery.new.user_id(user_id).preload_address
    store_dp   = UserStoreDeliveryPointQuery.new.user_id(user_id).preload_store

    result = Api::UserDeliveryPointsSerializer.new(address_dp, store_dp)

    response_success(delivery_points: result)
  rescue e
    response_error(500, e)
  end
end
