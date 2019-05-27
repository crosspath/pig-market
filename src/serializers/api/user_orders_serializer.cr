class Api::UserOrdersSerializer < Lucky::Serializer
  def initialize(@orders : Array(UserOrder) | UserOrderQuery); end

  def render
    @orders.map do |u|
      Api::UserOrderSerializer.new(
        u, with_items: false, with_bonus: false, with_delivery_point: false
      )
    end
  end
end
