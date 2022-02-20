class Api::Addresses::Index < ApiAction
  get "/api/addresses" do
    addresses = AddressQuery.new.city.asc_order

    result = Api::AddressSerializer.for_collection(addresses)

    response_success(addresses: result)
  rescue e
    response_error(500, e)
  end
end
