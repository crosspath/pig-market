class CategoryForm < Category::SaveOperation
  permit_columns path, name, description
end
