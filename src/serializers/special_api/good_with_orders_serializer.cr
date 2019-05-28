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
      res[:categories] = Api::CategoriesSerializer.new(@categories.not_nil!)
    end

    if @in_stores
      res[:in_stores] = Api::GoodsInStoresSerializer.new(@in_stores.not_nil!)
    end

    if @store_orders
      res[:store_orders] = Api::StoreOrdersSerializer.new(@store_orders.not_nil!)
    end

    if @user_orders
      res[:user_orders] = Api::UserOrdersSerializer.new(@user_orders.not_nil!)
    end

    res
  end
end
