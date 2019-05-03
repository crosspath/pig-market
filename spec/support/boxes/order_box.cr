class OrderBox < Avram::Box
  def initialize
    delivery_point_id 0
    planned_delivery_date Time.utc
    delivered_at Time.utc
    total_cost 0.0
    total_weight 0.0
    planned_delivery_time_interval 0
  end
end
