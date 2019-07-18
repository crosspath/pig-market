class UserStoreDeliveryPointForm < UserStoreDeliveryPoint::SaveOperation
  permit_columns user_id, store_id, hidden
end
