# Based on Avram::Queryable(T)#where
module Avram::Queryable(T)
  def where_in(statement : String, values : Array(Int16 | Int32 | Bool | String))
    query.raw_where(Avram::Where::RawIn.new(statement, values))
    self
  end
end

module Avram::Where
  class RawIn < Raw
    def initialize(statement : String, values : Array(Int16 | Int32 | Bool | String))
      ensure_enough_bind_variables_for!(statement, values)
      @clause = build_clause(statement, values)
    end

    private def ensure_enough_bind_variables_for!(statement, values)
      bindings = statement.chars.select(&.== '?')
      if bindings.size != values.size
        raise "wrong number of bind variables (#{values.size} for #{bindings.size}) in #{statement}"
      end
    end

    private def build_clause(statement, values)
      values.each do |arg|
        if arg.is_a?(String) || arg.is_a?(Slice(UInt8))
          escaped = PG::EscapeHelper.escape_literal(arg)
        else
          escaped = arg
        end
        statement = statement.sub('?', escaped)
      end
      statement
    end
  end
end
