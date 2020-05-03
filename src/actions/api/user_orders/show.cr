class Api::UserOrders::Show < ApiAction
  route do
    order = UserOrderQuery.new.find(user_order_id)
    items = OrderItemQuery.new.order_type(UserOrder.name).order_id(user_order_id).results

    address_dp = nil
    store_dp   = nil

    case order.delivery_point_type
    when UserAddressDeliveryPoint.name
      address_dp = UserAddressDeliveryPointQuery.find(order.delivery_point_id)
    when UserStoreDeliveryPoint.name
      store_dp = UserStoreDeliveryPointQuery.find(order.delivery_point_id)
    else
      nil
    end

    # BUG: Crystal compiler infers type BaseModel | Nil here if we use (address_dp || store_dp)
    #
    result = if address_dp
      Api::UserOrderSerializer.new(order, address_dp, items)
    else
      Api::UserOrderSerializer.new(order, store_dp, items)
    end

    response_success(order: result)
  rescue e
    response_error(500, e)
  end
end
