class Api::GoodsSerializer < Lucky::Serializer
  def initialize(@goods : Array(Good) | GoodQuery); end

  def render
    @goods.map do |u|
      unit = u.unit
      {
        id: u.id,
        name: u.name,
        description: u.description,
        price: u.price.round(2),
        weight: u.weight.round(2),
        unit: unit ? {
          id: unit.id,
          name: unit.name
        } : nil,
        categories: u.categories.map do |c|
          {
            id: c.id,
            name: c.name
          }
        end
      }
    end
  end
end
