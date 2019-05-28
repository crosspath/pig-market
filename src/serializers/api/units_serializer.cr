class Api::UnitsSerializer < Lucky::Serializer
  def initialize(@units : Array(Unit) | UnitQuery); end

  def render
    @units.map do |u|
      Api::UnitSerializer.new(u)
    end
  end
end
