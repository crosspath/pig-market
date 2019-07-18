class UserOrderForm < UserOrder::SaveOperation
  permit_columns delivery_point_type,
      delivery_point_id,
      planned_delivery_date,
      delivered_at,
      total_cost,
      total_weight,
      planned_delivery_time_interval,
      used_bonuses,
      earned_bonuses,
      earned_bonuses_state
end
