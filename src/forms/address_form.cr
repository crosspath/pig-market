class AddressForm < Address::SaveOperation
  permit_columns city, street, building
end
