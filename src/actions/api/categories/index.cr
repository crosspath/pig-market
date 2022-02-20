class Api::Categories::Index < ApiAction
  get "/api/categories" do
    categories = CategoryQuery.new.name.asc_order

    result = Api::CategorySerializer.for_collection(categories)

    response_success(categories: result)
  rescue e
    response_error(500, e)
  end
end
