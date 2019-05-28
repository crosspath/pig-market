class Api::AddressesSerializer < Lucky::Serializer
  def initialize(@addresses : Array(Address) | AddressQuery); end

  def render
    @addresses.map do |u|
      Api::AddressSerializer.new(u)
    end
  end
end
