class User < BaseModel
  table :users do
    has_one bonus_account : BonusAccount?
    has_many addresses : UsersAddress

    column login : String
    column crypted_password : String
    column first_name : String
    column last_name : String
    column full_name : String
    column birth_date : Time? # Only date
  end
end
