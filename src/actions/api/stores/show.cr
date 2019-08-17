class Api::Stores::Show < ApiAction
  route do
    store_query = StoreQuery.new.
        preload_address.
        preload_order_items.
        preload_user_store_delivery_points.
        preload_goods_in_stores.
        preload_store_orders

    store = store_query.find(store_id)

    good_ids = store.goods_in_stores.map(&.good_id).to_a.uniq
    goods = GoodQuery.new.id.in(good_ids).group_by(&.id)

    in_stores = store.goods_in_stores.map do |gs|
      {"gs" => gs, "g" => goods[gs.good_id]?.try(&.first), "s" => nil}
    end

    result = Api::StoreSerializer.new(
      store, store.address, in_stores, store.order_items, store.store_orders,
      store.user_store_delivery_points
    )

    response_success(store: result)
  rescue e
    response_error(500, e)
  end
end
