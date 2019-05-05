class AddressForm < Address::BaseForm
  fillable recipient_type, recipient_id, city, street, building, additional, hidden
end
