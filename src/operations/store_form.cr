class StoreForm < Store::SaveOperation
  permit_columns type, name, address_id, address_notes
end
