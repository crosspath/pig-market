require "./address.cr"

class Order < BaseModel
  table :orders do
    has_many bonus_changes : BonusChange
    has_many order_items : OrderItem

    belongs_to address : Address

    column planned_delivery_date : Time? # Only date
    column delivered_at : Time?
    column total_cost : Float64
    column total_weight : Float64
    column planned_delivery_time_interval : Int16?
  end
  
  enum DeliveryTime : Int16
    Morning
    Day
    Evening
  end
  
  DELIVERY_TIME_TEXT = ["08:00-12:00", "10:00-18:00", "18:00-22:00"]

  BONUS = 10 # percent

  def bonus_amount
    (self.total_cost * BONUS / 100.0).to_i
  end
end
