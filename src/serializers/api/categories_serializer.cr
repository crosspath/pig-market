class Api::CategoriesSerializer < Lucky::Serializer
  def initialize(@categories : Array(Category) | CategoryQuery); end

  def render
    @categories.map do |u|
      Api::CategorySerializer.new(u)
    end
  end
end
