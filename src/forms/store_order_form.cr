class StoreOrderForm < StoreOrder::BaseForm
  fillable user_id, store_id, planned_delivery_date, delivered_at, total_cost, total_weight
end
