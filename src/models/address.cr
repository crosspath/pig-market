class Address < BaseModel
  table do
    has_many stores : Store
    has_many user_address_delivery_points : UserAddressDeliveryPoint

    column city : String
    column street : String
    column building : String
  end

  macro add_default_columns
    column street : String
    column building : String
  end
end
