class Category < BaseModel
  table :categories do
    has_many goods_categories : GoodsCategory
    has_many goods : Good, :goods_categories # has_many through

    column path : String
    column name : String
    column description : String
  end
end
