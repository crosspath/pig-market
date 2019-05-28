class Api::GoodsInStoresSerializer < Lucky::Serializer
  def initialize(
    @records : Array(Tuple(GoodsInStore, Good?, Store?))
  ); end

  def render
    @records.map do |u|
      Api::GoodsInStoreSerializer.new(u)
    end
  end
end
