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

struct Int8
  module Lucky
    alias ColumnType = Int8
    include Avram::Type
    include ::DB::Mappable

    def self.from_db!(value : Int8)
      value
    end

    def self.parse(value : String)
      SuccessfulCast(Int8).new value.to_i8
    rescue ArgumentError
      FailedCast.new
    end

    def self.parse(value : Int8)
      SuccessfulCast(Int8).new(value)
    end

    def self.to_db(value : Int8)
      value.to_s
    end

    class Criteria(T, V) < Avram::Criteria(T, V)
    end
  end
  
  def blank?
    nil?
  end
end

module Avram::Migrator::ColumnDefaultHelpers
  alias ColumnDefaultType2 = Date | Int8

  def value_to_string(type : Date.class, value : Date)
    "'#{value}'"
  end

  def value_to_string(type : Int8.class, value : Int8 | Int16 | Int32)
    "#{value}"
  end

  def default_value(type : Int8.class, default : Int8 | Int16 | Int32)
    " DEFAULT #{value_to_string(type, default)}"
  end

  def default_value(type : Date.class, default : Date)
    " DEFAULT #{value_to_string(type, default.to_s)}"
  end
end

module Avram::Migrator::ColumnTypeOptionHelpers
  alias ColumnType2 = Date.class | Int8.class

  def column_type(type : Date.class)
    "date"
  end

  def column_type(type : Int8.class)
    "smallint"
  end
end

class Avram::Migrator::CreateTableStatement
  def add_column(name, type : ColumnType2, optional = false, reference = nil, on_delete = :do_nothing, default : ColumnDefaultType? | ColumnDefaultType2? = nil, options : NamedTuple? = nil)
    if options
      column_type_with_options = column_type(type, **options)
    else
      column_type_with_options = column_type(type)
    end

    rows << String.build do |row|
      row << "  "
      row << name.to_s
      row << " "
      row << column_type_with_options
      row << null_fragment(optional)
      row << default_value(type, default) unless default.nil?
      row << references(reference, on_delete)
    end
  end
end
