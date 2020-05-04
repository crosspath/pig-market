# We should `require` all models which are used in `belongs_to`,
# otherwise we will get error 'undefined constant'.

require "./good.cr"
require "./category.cr"

class GoodsCategory < BaseModel
  table do
    belongs_to good : Good
    belongs_to category : Category
  end
end
