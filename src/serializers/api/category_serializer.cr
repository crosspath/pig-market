class Api::CategorySerializer < Lucky::Serializer
  alias ManyRecords = CategoryQuery | Array(Category)
  alias ResultValue = Int32 | String | Api::GoodsSerializer | Api::CategoriesSerializer

  def initialize(
    @category : Category,
    @nested : ManyRecords | Nil = nil,
    @parents : ManyRecords | Nil = nil,
    @goods : Array(Good) | GoodQuery | Nil = nil
  ); end

  def render
    res = Hash(Symbol, ResultValue){
      id: @category.id,
      name: @category.name,
      path: @category.path,
      description: @category.description
    }

    if @goods
      res[:goods] = Api::GoodsSerializer.new(@goods)
    end

    if @nested
      res[:nested] = Api::CategoriesSerializer.new(@nested)
    end

    if @parents
      res[:parents] = Api::CategoriesSerializer.new(@parents)
    end

    res
  end
end
