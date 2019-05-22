class UserOrderForm < UserOrder::BaseForm
  fillable bonus_change_id,
      delivery_point_type,
      delivery_point_id,
      planned_delivery_date,
      delivered_at,
      total_cost,
      total_weight,
      planned_delivery_time_interval,
      used_bonuses
end
