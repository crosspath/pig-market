class Category < BaseModel
  table do
    has_many goods_categories : GoodsCategory
    has_many goods : Good, :goods_categories # has_many through

    column path : String
    column name : String
    column description : String
  end

  macro add_default_columns
    column path : String
    column description : String
  end

  def child_path
    self.path.blank? ? self.id.to_s : "#{self.path}.#{self.id}"
  end
end
