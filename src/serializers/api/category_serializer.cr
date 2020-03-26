class Api::CategorySerializer < BaseSerializer
  alias ManyRecords = CategoryQuery | Array(Category)

  def initialize(
    @category : Category,
    @nested : ManyRecords | Nil = nil,
    @parents : ManyRecords | Nil = nil,
    @goods : Array(Good) | GoodQuery | Nil = nil
  ); end

  def render
    res = Hash(Symbol, ResultValue){
      :id => @category.id,
      :name => @category.name,
      :path => @category.path,
      :description => @category.description
    }

    if @goods
      items = Api::GoodSerializer.for_collection(@goods.not_nil!)
      res[:goods] = items
    end

    if @nested
      items = Api::CategorySerializer.for_collection(@nested.not_nil!)
      res[:nested] = items
    end

    if @parents
      items = Api::CategorySerializer.for_collection(@parents.not_nil!)
      res[:parents] = items
    end

    res
  end
end
