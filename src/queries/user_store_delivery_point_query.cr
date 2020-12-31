require "../models/user_store_delivery_point.cr"

class UserStoreDeliveryPointQuery < UserStoreDeliveryPoint::BaseQuery
  def for_user(id)
    user_id(id).map(&.id)
  end
end
