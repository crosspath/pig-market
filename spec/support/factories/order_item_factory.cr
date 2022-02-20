class OrderItemFactory < Avram::Factory
  def initialize
    order_type "UserOrder"
    order_id 0
    store_id 0
    good_id 0
    price 0.0
    weight_of_packaged_items 0.0
    amount 1
  end
end
