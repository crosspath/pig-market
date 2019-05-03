class Address < BaseModel
  table :addresses do
    has_many users_addresses : UsersAddress
    has_many users : User, :users_addresses
    has_many stores : Store

    column city : String
    column street : String
    column building : String
    column additional : String
  end
end
