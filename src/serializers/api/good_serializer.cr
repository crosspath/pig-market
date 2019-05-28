class Api::GoodSerializer < Lucky::Serializer
  alias ResultValue = Int32 | String | Float | Api::UnitSerializer
    | Api::CategoriesSerializer | Api::GoodsInStoresSerializer | Api::OrderItemsSerializer

  def initialize(
    @good : Good,
    @unit : Unit | Nil = nil,
    @categories : CategoryQuery | Array(Category) | Nil = nil,
    @in_stores : Array(Tuple(GoodsInStore, Good?, Store?)) | Nil = nil,
    @order_items : OrderItemQuery | Array(OrderItem) | Nil = nil
  ); end

  def render
    res = Hash(Symbol, ResultValue){
      id: @good.id,
      name: @good.name,
      description: @good.description,
      price: @good.price.round(2),
      weight: @good.weight.round(2)
    }

    if @unit
      res[:unit] = Api::UnitSerializer.new(@unit)
    end

    if @categories
      res[:categories] = Api::CategoriesSerializer.new(@categories)
    end

    if @in_stores
      res[:in_stores] = Api::GoodsInStoresSerializer.new(@in_stores)
    end

    if @order_items
      res[:order_items] = Api::OrderItemsSerializer.new(@order_items)
    end

    res
  end
end
