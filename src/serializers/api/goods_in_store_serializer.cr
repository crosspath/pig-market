class Api::GoodsInStoreSerializer < Lucky::Serializer
  alias ResultValue = Int16 | Api::GoodSerializer | Api::StoreSerializer

  def initialize(
    @record : Tuple(GoodsInStore, Good?, Store?)
  ); end

  def render
    res = Hash(Symbol, ResultValue){
      amount: @record[0].amount
    }

    if @record[1]
      res[:good] = Api::GoodSerializer.new(@record[1])
    end

    if @record[2]
      res[:store] = Api::StoreSerializer.new(@record[2])
    end

    res
  end
end
