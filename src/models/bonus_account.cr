# We should `require` all models which are used in `belongs_to`,
# otherwise we will get error 'undefined constant'.

require "./user.cr"

class BonusAccount < BaseModel
  table :bonus_accounts do
    has_many bonus_changes : BonusChange

    belongs_to user : User

    column amount : Int16

    default({:amount => 0})
  end
end
