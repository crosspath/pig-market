class Api::Stores::Show < ApiAction
  route do
    store = StoreQuery.new.preload_goods_in_stores.find(store_id)

    good_ids = store.goods_in_stores.map(&.good_id).to_a
    goods = GoodQuery.new.id.in(good_ids).group_by(&.id)

    result = Api::StoreSerializer.new(store, goods)

    response_success(store: result)
  rescue e
    response_error(500, e)
  end
end
