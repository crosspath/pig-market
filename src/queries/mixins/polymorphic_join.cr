# Based on avram/src/avram/join.cr, Avram::Join
module PolymorphicJoin
  extend Avram::Join

  abstract class SqlClause
    def initialize(
      @from : Symbol,
      @to : Symbol,
      @polymorphic_type : Symbol,
      @polymorphic_value : String? = nil,
      @primary_key : Symbol? = nil,
      @comparison : String? = "=",
      @using : Array(Symbol) = [] of Symbol
    )
    end

    def to_column
      connect_by_id = "#{@to}.#{@polymorphic_type}_id"
      "#{connect_by_id}#{connect_by_type(@id)}"
    end

    def connect_by_type(table_name : String)
      if @polymorphic_value
        " AND #{table_name}.#{@polymorphic_type}_type = '#{@polymorphic_value}'"
      else
        ""
      end
    end
  end
end

module PolymorphicJoinBelongs
  extend PolymorphicJoin

  abstract class SqlClause
    def to_column
      connect_by_id = "#{@to}.#{@polymorphic_type}_id"
      "#{connect_by_id}#{connect_by_type(@from)}"
    end
  end
end
