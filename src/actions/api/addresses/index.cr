class Api::Addresses::Index < ApiAction
  route do
    addresses = AddressQuery.new.city.asc_order

    result = Api::AddressesSerializer.new(addresses)

    response_success(addresses: result)
  rescue e
    response_error(500, e)
  end
end
