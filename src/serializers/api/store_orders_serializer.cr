class Api::StoreOrdersSerializer < Lucky::Serializer
  def initialize(@orders : Array(StoreOrder) | StoreOrderQuery); end

  def render
    @orders.map do |u|
      Api::StoreOrderSerializer.new(u)
    end
  end
end
