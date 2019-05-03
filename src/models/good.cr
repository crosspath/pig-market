require "./unit.cr"

class Good < BaseModel
  table :goods do
    has_many goods_categories : GoodsCategory
    has_many categories : Category, :goods_categories # has_many through
    has_many items : OrderItem
    has_many in_stores : GoodsInStore
    
    belongs_to unit : Unit?

    column name : String
    column description : String
    column price : Float64
    column weight : Float64
  end
end