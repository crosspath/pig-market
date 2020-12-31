require "../models/user_address_delivery_point.cr"

class UserAddressDeliveryPointQuery < UserAddressDeliveryPoint::BaseQuery
  def for_user(id)
    select(:id).user_id(id).results.map(&.id).to_a
  end
end
