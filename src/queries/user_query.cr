require "../models/user.cr"

class UserQuery < User::BaseQuery
  def preload_addresses
    
  end
end
