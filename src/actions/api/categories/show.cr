class Api::Categories::Show < ApiAction
  route do
    category = CategoryQuery.new.find(category_id)
    child_path = category.child_path
    parent_ids = category.path.empty? ? nil : category.path.split(".")

    nested = CategoryQuery.new.where(
      "path like ? or path = ?",
      "#{child_path}.%",
      child_path
    ).path.asc_order.results

    parents = if parent_ids
      CategoryQuery.new.id.in(parent_ids).path.asc_order
    else
      [] of Category
    end

    category_ids = ([category_id.to_i] + nested.map(&.id).to_a).join(", ")
    goods = GoodQuery.new.join_goods_categories.where("category_id in (#{category_ids})")
    goods = goods.distinct.name.asc_order

    result = Api::CategorySerializer.new(category, nested, parents, goods)

    response_success(category: result)
  rescue e
    response_error(500, e)
  end
end
