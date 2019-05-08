class Api::CategoriesSerializer < Lucky::Serializer
  def initialize(@categories : Array(Category) | CategoryQuery); end

  def render
    @categories.map do |u|
      {
        id: u.id,
        name: u.name,
        path: u.path,
        description: u.description
      }
    end
  end
end
