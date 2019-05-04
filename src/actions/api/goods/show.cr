class Api::Goods::Show < ApiAction
  route do
    query = GoodQuery.new
    query = query.preload_categories.preload_unit
    query = query.preload_goods_in_stores

    good = query.find(good_id)

    store_ids = good.goods_in_stores.map(&.store_id).to_a
    stores = StoreQuery.new.id.in(store_ids).group_by(&.id)

    result = Api::GoodSerializer.new(good, stores)

    response_success(good: result)
  rescue e
    response_error(500, e)
  end
end
