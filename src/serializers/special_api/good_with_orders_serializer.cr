class SpecialApi::GoodWithOrdersSerializer < Lucky::Serializer
  alias InStoresValue = GoodsInStore | Good | Store | Nil
  alias ResultValue = Int32 | String | Float64 | Lucky::Serializer | Array(Lucky::Serializer)

  def initialize(
    @good : Good,
    @unit : Unit | Nil = nil,
    @categories : CategoryQuery | Array(Category) | Nil = nil,
    @in_stores : Array(Hash(String, InStoresValue)) | Nil = nil,
    @store_orders : StoreOrderQuery | Array(StoreOrder) | Nil = nil,
    @user_orders : UserOrderQuery | Array(UserOrder) | Nil = nil
  ); end

  def render
    res = Hash(Symbol, ResultValue){
      :id => @good.id,
      :name => @good.name,
      :description => @good.description,
      :price => @good.price.round(2),
      :weight => @good.weight.round(2)
    }

    if @unit
      res[:unit] = Api::UnitSerializer.new(@unit.not_nil!)
    end

    if @categories
      items = Api::CategorySerializer.for_collection(@categories.not_nil!)
      res[:categories] = items
    end

    if @in_stores
      items = Api::GoodsInStoreSerializer.for_collection(@in_stores.not_nil!)
      res[:in_stores] = items
    end

    if @store_orders
      items = Api::StoreOrderSerializer.for_collection(@store_orders.not_nil!)
      res[:store_orders] = items
    end

    if @user_orders
      items = Api::UserOrderSerializer.for_collection(@user_orders.not_nil!)
      res[:user_orders] = items
    end

    res
  end
end
