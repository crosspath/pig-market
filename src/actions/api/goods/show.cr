class Api::Goods::Show < ApiAction
  route do
    query = GoodQuery.new
    query = query.preload_categories.preload_unit.preload_order_items.preload_goods_in_stores

    good = query.find(good_id)

    store_ids = good.goods_in_stores.map(&.store_id).to_a.uniq
    stores = StoreQuery.new.id.in(store_ids).group_by(&.id)

    in_stores = good.goods_in_stores.map do |gs|
      {gs, nil, stores[gs.store_id]?.try(&.first)}
    end

    result = Api::GoodSerializer.new(
      good, good.unit, good.categories, in_stores, good.order_items
    )

    response_success(good: result)
  rescue e
    response_error(500, e)
  end
end
