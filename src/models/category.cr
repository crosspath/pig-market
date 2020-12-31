class Category < BaseModel
  table do
    has_many goods_categories : GoodsCategory
    has_many goods : Good, through: [:goods_categories, :goods]

    column path : String
    column name : String
    column description : String
  end

  def child_path
    self.path.blank? ? self.id.to_s : "#{self.path}.#{self.id}"
  end
end
