require "./bonus_account.cr"
require "./order.cr"

class BonusChange < BaseModel
  table :bonus_changes do
    belongs_to bonus_account : BonusAccount
    belongs_to order : Order?

    column change : Int16
    column state : Int16
  end
end
