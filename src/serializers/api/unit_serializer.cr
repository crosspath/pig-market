class Api::UnitSerializer < BaseSerializer
  def initialize(
    @unit : Unit,
    @goods : GoodQuery | Array(Good) | Nil = nil
  ); end

  def render
    res = Hash(Symbol, ResultValue){
      :id => @unit.id,
      :name => @unit.name
    }

    if @goods
      items = Api::GoodSerializer.for_collection(@goods.not_nil!)
      res[:goods] = items
    end

    res
  end
end
