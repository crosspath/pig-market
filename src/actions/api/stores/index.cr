class Api::Stores::Index < ApiAction
  route do
    stores = StoreQuery.new.name.asc_order

    result = Api::StoresSerializer.new(stores)

    response_success(stores: result)
  rescue e
    response_error(500, e)
  end
end
