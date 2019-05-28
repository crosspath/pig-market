class Api::GoodsSerializer < Lucky::Serializer
  def initialize(@goods : Array(Good) | GoodQuery); end

  def render
    @goods.map do |u|
      Api::GoodSerializer.new(u)
    end
  end
end
