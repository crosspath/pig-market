class OrderForm < Order::BaseForm
  fillable address_id,
      planned_delivery_date,
      delivered_at,
      total_cost,
      total_weight,
      planned_delivery_time_interval
end
