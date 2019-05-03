class Unit < BaseModel
  table :units do
    has_many goods : Good

    column name : String
  end
end
