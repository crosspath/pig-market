class Api::StoreOrders::Index < ApiAction
  route do
    orders = StoreOrderQuery.new.created_at.asc_order

    result = Api::StoreOrdersSerializer.new(orders)

    response_success(orders: result)
  rescue e
    response_error(500, e)
  end
end
