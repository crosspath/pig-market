class OrderItemForm < OrderItem::BaseForm
  fillable order_id, from_store_id, good_id, price, weight_of_packaged_items, amount
end
