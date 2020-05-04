class Unit < BaseModel
  table do
    has_many goods : Good

    column name : String
  end
end
