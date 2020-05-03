struct Date
  property time : Time

  def initialize(@time : Time); end

  def to_s(format : String = "%Y-%m-%d")
    @time.to_utc.to_s(format)
  end

  def blank?
    nil?
  end
end

class Avram::Migrator::Columns::DateColumn(T) < Avram::Migrator::Columns::Base
  @default : Date | Nil = nil

  def initialize(@name, @nilable, @default)
  end

  def column_type : String
    "date"
  end

  def self.prepare_value_for_database(value)
    value.to_s
  end
end
