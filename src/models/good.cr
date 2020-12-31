require "./unit.cr"

class Good < BaseModel
  table do
    has_many goods_categories : GoodsCategory
    has_many categories : Category, through: [:goods_categories, :category]
    has_many order_items : OrderItem
    has_many goods_in_stores : GoodsInStore
    has_many stores : Store, through: [:goods_in_stores, :store]

    belongs_to unit : Unit?

    column name : String
    column description : String
    column price : Float64
    column weight : Float64
  end
end
