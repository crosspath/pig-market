class Address < BaseModel
  table :addresses do
    has_many stores : Store
    has_many user_address_delivery_points : UserAddressDeliveryPoint

    column city : String
    column street : String
    column building : String

    default({street: "", building: ""})
  end
end
