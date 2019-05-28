class Api::UserOrders::Show < ApiAction
  route do
    order = UserOrderQuery.new.find(user_order_id)
    items = OrderItemQuery.new.order_type(UserOrder.name).order_id(user_order_id).results

    # BUG: Crystal compiler infers type BaseModel | Nil for this `case`, not
    # UserAddressDeliveryPoint | UserStoreDeliveryPoint | Nil
    #
    case order.delivery_point_type
    when UserAddressDeliveryPoint.name
      delivery_point = UserAddressDeliveryPointQuery.find(order.delivery_point_id)
      result = Api::UserOrderSerializer.new(order, delivery_point, items)
    when UserStoreDeliveryPoint.name
      delivery_point = UserStoreDeliveryPointQuery.find(order.delivery_point_id)
      result = Api::UserOrderSerializer.new(order, delivery_point, items)
    else
      delivery_point = nil
      result = Api::UserOrderSerializer.new(order, delivery_point, items)
    end

    response_success(order: result)
  rescue e
    response_error(500, e)
  end
end
