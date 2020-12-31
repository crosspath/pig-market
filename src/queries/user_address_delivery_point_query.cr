require "../models/user_address_delivery_point.cr"

class UserAddressDeliveryPointQuery < UserAddressDeliveryPoint::BaseQuery
  def for_user(id)
    user_id(id).map(&.id)
  end
end
