class Api::Categories::Index < ApiAction
  route do
    categories = CategoryQuery.new.name.asc_order

    result = Api::CategoriesSerializer.new(categories)

    response_success(categories: result)
  rescue e
    response_error(500, e)
  end
end
