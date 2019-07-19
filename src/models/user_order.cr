require "./user_address_delivery_point.cr"
require "./user_store_delivery_point.cr"

class UserOrder < BaseModel
  table :user_orders do
    # TODO: has_many_polymorphic order_items : OrderItem, :order

    polymorphic delivery_point : UserStoreDeliveryPoint | UserAddressDeliveryPoint
    # column delivery_point_type : String
    # column delivery_point_id : Int32
    
    column planned_delivery_date : Time? # Only date
    column delivered_at : Time?
    column total_cost : Float64
    column total_weight : Float64
    column planned_delivery_time_interval : Int16?
    column used_bonuses : Int16
    column earned_bonuses : Int16
    column earned_bonuses_state : Int16
    
    default({used_bonuses: 0.to_i16, earned_bonuses_state: 0.to_i16})
  end
  
  enum DeliveryTime : Int16
    Morning
    Day
    Evening
  end

  enum EarnedBonusesState : Int16
    Created
    Activated
    Rejected
  end
  
  DELIVERY_TIME_TEXT = ["08:00-12:00", "10:00-18:00", "18:00-22:00"]

  BONUS = 10 # percent

  def bonus_amount
    self.class.bonus_amount(self.total_cost)
  end

  def self.bonus_amount(total_cost)
    (total_cost * BONUS / 100.0).to_i16
  end
end
