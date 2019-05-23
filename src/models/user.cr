class User < BaseModel
  table :users do
    has_many user_store_delivery_points : UserStoreDeliveryPoint
    has_many user_address_delivery_points : UserAddressDeliveryPoint

    column login : String
    column crypted_password : String
    column first_name : String
    column last_name : String
    column full_name : String
    column birth_date : Time? # Only date
    column bonuses : Int32
    column role : Int16

    default({:first_name => "", :last_name => "", :full_name => "", :birth_date => nil, :bonuses => 0, :role => 0})
  end
  
  enum UserRole : Int16
    Customer
    Worker
  end
end
