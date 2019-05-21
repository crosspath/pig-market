class BonusChange < BaseModel
  table :bonus_changes do
    has_many user_orders : UserOrder

    column change : Int16
    column state : Int16

    default({:state => 0}) # Created
  end

  enum State : Int16
    Created
    Activated
    Rejected
  end
end
