class Api::CategorySerializer < Lucky::Serializer
  alias ManyRecords = CategoryQuery | Array(Category)
  def initialize(@category : Category, @nested : ManyRecords, @parents : ManyRecords); end

  def render
    {
      id: @category.id,
      name: @category.name,
      path: @category.path,
      description: @category.description,
      goods: @category.goods.map do |u|
        {
          id: u.id,
          name: u.name
        }
      end,
      nested: Api::CategoriesSerializer.new(@nested),
      parents: Api::CategoriesSerializer.new(@parents)
    }
  end
end
