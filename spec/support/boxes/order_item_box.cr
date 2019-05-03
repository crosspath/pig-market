class OrderItemBox < Avram::Box
  def initialize
    order_id 0
    from_store_id 0
    good_id 0
    price 0.0
    weight_of_packaged_items 0.0
    amount 1
  end
end
