class UserAddressDeliveryPointForm < UserAddressDeliveryPoint::SaveOperation
  permit_columns user_id, address_id, address_notes, hidden
end
