class Api::GoodsInStoresSerializer < Lucky::Serializer
  alias InStoresValue = GoodsInStore | Good | Store | Nil

  def initialize(
    @records : Array(Hash(String, InStoresValue))
  ); end

  def render
    @records.map do |u|
      Api::GoodsInStoreSerializer.new(u)
    end
  end
end
