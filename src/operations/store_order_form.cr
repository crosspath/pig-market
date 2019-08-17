class StoreOrderForm < StoreOrder::SaveOperation
  permit_columns user_id, store_id, planned_delivery_date, delivered_at, total_cost, total_weight
end
