# We should `require` all models which are used in `belongs_to`,
# otherwise we will get error 'undefined constant'.

require "./user.cr"
require "./address.cr"

class UsersAddress < BaseModel
  table :users_addresses do
    belongs_to user : User
    belongs_to address : Address
    
    column hidden : Boolean
  end
end
