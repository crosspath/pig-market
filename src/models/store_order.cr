class StoreOrder < BaseModel
  table :store_orders do
    # TODO: has_many_polymorphic order_items : OrderItem, :order
    
    belongs_to store : Store

    column planned_delivery_date : Time? # Only date
    column delivered_at : Time?
    column total_cost : Float64
    column total_weight : Float64
  end
end
