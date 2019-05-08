class Api::StoresSerializer < Lucky::Serializer
  def initialize(@stores : Array(Store) | StoreQuery); end

  def render
    @stores.map do |u|
      {
        id: u.id,
        name: u.name,
        type: u.type
      }
    end
  end
end
