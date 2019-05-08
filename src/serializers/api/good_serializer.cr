class Api::GoodSerializer < Lucky::Serializer
  def initialize(@good : Good, @stores : Hash(Int32, Array(Store))); end

  def render
    unit = @good.unit

    {
      id: @good.id,
      name: @good.name,
      description: @good.description,
      price: @good.price.round(2),
      weight: @good.weight.round(2),
      unit: unit ? {
        id: unit.id,
        name: unit.name
      } : nil,
      categories: @good.categories.map do |u|
        {
          id: u.id,
          name: u.name
        }
      end,
      in_stores: @good.goods_in_stores.map do |u|
        store = @stores.has_key?(u.store_id) ? @stores[u.store_id].first : nil
        {
          amount: u.amount,
          store: store ? {
            id: store.id,
            type: store.type,
            type_name: Store::StoreType.new(store.type).to_s,
            name: store.name
          } : nil
        }
      end
    }
  end
end
