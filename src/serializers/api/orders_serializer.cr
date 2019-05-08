class Api::OrdersSerializer < Lucky::Serializer
  def initialize(@orders : Array(Order) | OrderQuery, @addresses : Bool = false, @items : Bool = false); end

  def render
    @orders.map do |u|
      Api::OrderSerializer.new(u, addresses: @addresses, items: @items)
    end
  end
end
