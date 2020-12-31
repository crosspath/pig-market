require "../models/user_store_delivery_point.cr"

class UserStoreDeliveryPointQuery < UserStoreDeliveryPoint::BaseQuery
  def for_user(id)
    select(:id).user_id(id).results.map(&.id).to_a
  end
end
