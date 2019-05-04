class Api::UnitSerializer < Lucky::Serializer
  def initialize(@unit : Unit); end

  def render
    {
      id: @unit.id,
      name: @unit.name,
      goods: @unit.goods.map do |u|
        {
          id: u.id,
          name: u.name
        }
      end
    }
  end
end
