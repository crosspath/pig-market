class Api::StoreSerializer < Lucky::Serializer
  def initialize(@store : Store, @goods : Hash(Int32, Array(Good))); end

  def render
    {
      id: @store.id,
      name: @store.name,
      type: @store.type,
      in_stores: @store.goods_in_stores.map do |a|
        good = @goods.has_key?(a.good_id) ? @goods[a.good_id].first : nil
        {
          amount: a.amount,
          goods: good ? {
            id: good.id,
            name: good.name
          } : nil
        }
      end
    }
  end
end
