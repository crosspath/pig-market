class DeliveryPoint < BaseModel
  table :delivery_points do
    # polymorphic: UsersAddress or Store
    column point_type : String
    column point_id : Int32
  end
end
