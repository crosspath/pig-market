class Api::UserOrdersSerializer < Lucky::Serializer
  def initialize(@orders : Array(UserOrder) | UserOrderQuery); end

  def render
    @orders.map do |u|
      Api::UserOrderSerializer.new(u)
    end
  end
end
