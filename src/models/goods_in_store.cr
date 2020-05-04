# We should `require` all models which are used in `belongs_to`,
# otherwise we will get error 'undefined constant'.

require "./good.cr"
require "./store.cr"

class GoodsInStore < BaseModel
  table do
    belongs_to good : Good
    belongs_to store : Store

    column amount : Int16
  end

  macro add_default_columns
    column amount : Int16
  end
end
