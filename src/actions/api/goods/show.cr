class Api::Goods::Show < ApiAction
  get "/api/goods/:good_id" do
    query = GoodQuery.new
    query = query.preload_categories.preload_unit.preload_order_items.preload_goods_in_stores

    good = query.find(good_id)

    store_ids = good.goods_in_stores.map(&.store_id).to_a.uniq
    stores = StoreQuery.new.id.in(store_ids).group_by(&.id)

    in_stores = good.goods_in_stores.map do |gs|
      {"gs" => gs, "g" => nil, "s" => stores[gs.store_id]?.try(&.first)}
    end

    orders_groups   = good.order_items.group_by(&.order_type)
    store_order_ids = orders_groups[StoreOrder.name]?.try(&.map(&.order_id).to_a)
    user_order_ids  = orders_groups[UserOrder.name]?.try(&.map(&.order_id).to_a)

    store_orders = if store_order_ids.nil? || store_order_ids.empty?
      [] of StoreOrder
    else
      StoreOrderQuery.new.id.in(store_order_ids).results
    end

    user_orders = if user_order_ids.nil? || user_order_ids.empty?
      [] of UserOrder
    else
      UserOrderQuery.new.id.in(user_order_ids).results
    end

    result = SpecialApi::GoodWithOrdersSerializer.new(
      good, good.unit, good.categories, in_stores, store_orders, user_orders
    )

    response_success(good: result)
  rescue e
    response_error(500, e)
  end
end
