class GoodsInStoreForm < GoodsInStore::SaveOperation
  permit_columns good_id, store_id, amount
end
