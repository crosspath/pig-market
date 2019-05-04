class Api::UnitsSerializer < Lucky::Serializer
  def initialize(@units : Array(Unit) | UnitQuery); end

  def render
    @units.map do |u|
      {
        id: u.id,
        name: u.name
      }
    end
  end
end
