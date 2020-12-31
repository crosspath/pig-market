module PolymorphicWhere
  def polymorphic_where_in(
    assoc_name : String | Symbol,
    type : String,
    ids : Array(Int32)
  )
    if ids.empty?
      none
    else
      q = "?" + ",?" * (ids.size - 1)
      where("(#{assoc_name}_type = '#{type}' and #{assoc_name}_id in (#{q}))", args: ids)
    end
  end
end
