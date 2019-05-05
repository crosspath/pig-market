class User < BaseModel
  table :users do
    has_one bonus_account : BonusAccount?

    column login : String
    column crypted_password : String
    column first_name : String
    column last_name : String
    column full_name : String
    column birth_date : Time? # Only date

    default({:first_name => "", :last_name => "", :full_name => ""})
  end

  # polymorphic
  def addresses
    
  end
end
