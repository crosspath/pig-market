class User < BaseModel
  table do
    has_many user_store_delivery_points : UserStoreDeliveryPoint
    has_many user_address_delivery_points : UserAddressDeliveryPoint

    column login : String
    column crypted_password : String
    column first_name : String
    column last_name : String
    column full_name : String
    column birth_date : Time? # Only date
    column bonuses : Int16
    column role : Int16
  end

  macro add_default_columns
    column first_name : String
    column last_name : String
    column full_name : String
    column birth_date : Time?
    column bonuses : Int16
    column role : Int16
  end

  enum UserRole : Int16
    Customer
    Worker
  end

  def encrypted_password : String | Nil
    crypted_password
  end
end
