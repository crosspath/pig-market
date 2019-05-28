class Api::StoresSerializer < Lucky::Serializer
  def initialize(@stores : Array(Store) | StoreQuery); end

  def render
    @stores.map do |u|
      Api::StoreSerializer.new(u)
    end
  end
end
