class GoodsCategoryForm < GoodsCategory::SaveOperation
  permit_columns good_id, category_id
end
