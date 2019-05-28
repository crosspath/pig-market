class Api::Users::DeliveryPoints < ApiAction
  get "/api/users/:user_id/delivery_points" do
    address_dp = UserAddressDeliveryPointQuery.new.user_id(user_id).preload_address
    store_dp   = UserStoreDeliveryPointQuery.new.user_id(user_id).preload_store

    address_ids = store_dp.map(&.store.try(&.address_id)).uniq.to_a
    addresses = AddressQuery.new.id.in(address_ids).group_by(&.id)

    result = SpecialApi::DeliveryPointsWithAddressSerializer.new(address_dp, store_dp, addresses)

    response_success(delivery_points: result)
  rescue e
    response_error(500, e)
  end
end
