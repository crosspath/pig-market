module PolymorphicWhere
  def polymorphic_where_in(assoc_name : String, type : String, ids : Array(Int32)) : Avram::QueryBuilder
    if ids.empty?
      none
    else
      q = "?" + ",?" * (ids.size - 1)
      where("(#{assoc_name}_type = '#{type}' and #{assoc_name}_id in (#{q}))", ids)
    end
  end
end
