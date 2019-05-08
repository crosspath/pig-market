class Api::Categories::Show < ApiAction
  route do
    category = CategoryQuery.new.preload_goods.find(category_id)
    child_path = category.child_path
    parent_ids = category.path.split(".")

    nested = CategoryQuery.new.where(
      "path like ? or path = ?",
      "#{child_path}.%",
      child_path
    )

    parents = CategoryQuery.new.id.in(parent_ids)

    result = Api::CategorySerializer.new(category, nested, parents)

    response_success(category: result)
  rescue e
    response_error(500, e)
  end
end
