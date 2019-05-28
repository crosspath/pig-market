class Api::OrderItemsSerializer < Lucky::Serializer
  def initialize(@items : Array(OrderItem) | OrderItemQuery); end

  def render
    @items.map do |u|
      Api::OrderItemSerializer.new(u)
    end
  end
end
