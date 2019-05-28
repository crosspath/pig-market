class UserOrderBox < Avram::Box
  def initialize
    delivery_point_type "UserStoreDeliveryPoint"
    delivery_point_id 0
    planned_delivery_date Time.utc
    delivered_at Time.utc
    total_cost 0.0
    total_weight 0.0
    planned_delivery_time_interval 0
    used_bonuses 0
    earned_bonuses 0
    earned_bonuses_state 0
  end
end
