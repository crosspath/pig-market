class Api::UnitSerializer < Lucky::Serializer
  alias ResultValue = Int32 | String | Api::GoodsSerializer

  def initialize(
    @unit : Unit,
    @goods : GoodQuery | Array(Good) | Nil = nil
  ); end

  def render
    res = Hash(Symbol, ResultValue){
      id: @unit.id,
      name: @unit.name
    }

    if @goods
      res[:goods] = Api::GoodsSerializer.new(@goods)
    end

    res
  end
end
