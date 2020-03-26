class Api::GoodSerializer < BaseSerializer
  alias InStoresValue = GoodsInStore | Good | Store | Nil

  def initialize(
    @good : Good,
    @unit : Unit | Nil = nil,
    @categories : CategoryQuery | Array(Category) | Nil = nil,
    @in_stores : Array(Hash(String, InStoresValue)) | Nil = nil,
    @order_items : OrderItemQuery | Array(OrderItem) | Nil = nil
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

    if @order_items
      items = Api::OrderItemSerializer.for_collection(@order_items.not_nil!)
      res[:order_items] = items
    end

    res
  end
end
