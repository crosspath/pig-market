class Api::Stores::Index < ApiAction
  get "/api/stores" do
    stores = StoreQuery.new.name.asc_order

    result = Api::StoreSerializer.for_collection(stores)

    response_success(stores: result)
  rescue e
    response_error(500, e)
  end
end
