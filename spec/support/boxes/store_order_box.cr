class StoreOrderBox < Avram::Box
  def initialize
    store_id 0
    planned_delivery_date Time.utc
    delivered_at Time.utc
    total_cost 0.0
    total_weight 0.0
  end
end
