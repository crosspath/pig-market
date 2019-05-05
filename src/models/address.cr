class Address < BaseModel
  table :addresses do
    has_many orders : Order

    column recipient_type : String
    column recipient_id : Int32
    column city : String
    column street : String
    column building : String
    column additional : String
    column hidden : Bool

    default({:street => "", :building => "", :additional => ""})
  end

  # polymorphic: User or Store
  def recipient
    
  end
end
