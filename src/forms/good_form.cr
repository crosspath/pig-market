class GoodForm < Good::SaveOperation
  permit_columns name, unit_id, description, price, weight
end
