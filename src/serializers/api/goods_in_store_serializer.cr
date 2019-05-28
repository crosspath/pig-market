class Api::GoodsInStoreSerializer < Lucky::Serializer
  alias InStoresValue = GoodsInStore | Good | Store | Nil
  alias ResultValue = Int16 | Nil | Lucky::Serializer

  def initialize(
    @record : Hash(String, InStoresValue)
  ); end

  def render
    res = Hash(Symbol, ResultValue){
      :amount => @record["gs"]?.as(GoodsInStore?).try(&.amount)
    }

    if @record["g"]
      res[:good] = Api::GoodSerializer.new(@record["g"].as(Good?).not_nil!)
    end

    if @record["s"]
      res[:store] = Api::StoreSerializer.new(@record["s"].as(Store?).not_nil!)
    end

    res
  end
end
