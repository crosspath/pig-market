class Api::Addresses::Show < ApiAction
  route do
    address_query = AddressQuery.new.preload_stores.preload_user_address_delivery_points

    address = address_query.find(address_id)

    result = Api::AddressSerializer.new(
      address, address.stores, address.user_address_delivery_points
    )

    response_success(address: result)
  rescue e
    response_error(500, e)
  end
end
