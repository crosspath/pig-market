require "./delivery_point.cr"

class Order < BaseModel
  table :orders do
    has_many bonus_changes : BonusChange
    has_many items : OrderItem

    belongs_to delivery_point : DeliveryPoint

    column planned_delivery_date : Time? # Only date
    column delivered_at : Time?
    column total_cost : Float64
    column total_weight : Float64
    column planned_delivery_time_interval : Int32?
  end

  BONUS = 10 # percent

  def bonus_amount
    (self.total_cost * BONUS / 100.0).to_i
  end
end
