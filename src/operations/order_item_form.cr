class OrderItemForm < OrderItem::SaveOperation
  permit_columns order_type, order_id, store_id, good_id, price, weight_of_packaged_items, amount
end
