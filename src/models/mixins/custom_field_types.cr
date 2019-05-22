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

struct Int16
  module Lucky
    alias ColumnType = Int16
    include Avram::Type
    include ::DB::Mappable

    def self.from_db!(value : Int16)
      value
    end

    def self.parse(value : String)
      SuccessfulCast(Int16).new value.to_i16
    rescue ArgumentError
      FailedCast.new
    end

    def self.parse(value : Int16)
      SuccessfulCast(Int16).new(value)
    end

    def self.to_db(value : Int16)
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
  alias ColumnDefaultType2 = Date | Int16

  def value_to_string(type : Date.class, value : Date)
    "'#{value}'"
  end

  def value_to_string(type : Int16.class, value : Int16 | Int32)
    "#{value}"
  end

  def default_value(type : Int16.class, default : Int16 | Int32)
    " DEFAULT #{value_to_string(type, default)}"
  end

  def default_value(type : Date.class, default : Date)
    " DEFAULT #{value_to_string(type, default.to_s)}"
  end
end

module Avram::Migrator::ColumnTypeOptionHelpers
  alias ColumnType2 = Date.class | Int16.class

  def column_type(type : Date.class)
    "date"
  end

  def column_type(type : Int16.class)
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

class Avram::Model
  alias DefaultValueType =
      Avram::Migrator::ColumnDefaultHelpers::ColumnDefaultType |
      Avram::Migrator::ColumnDefaultHelpers::ColumnDefaultType2

  macro inherited
    DEFAULT_VALUES = Hash(Symbol, DefaultValueType).new
  end

  macro polymorphic(name_and_type)
    {% var = name_and_type.var %}
    {% type = name_and_type.type %}
    {% nilable = type.types.includes?(Nil) %}
    column {{ var }}_type : String
    column {{ var }}_id : Int32
    
    # Based on avram/src/avram/associations.cr, define_belongs_to_private_assoc_getter
    private def get_{{ var }}(allow_lazy : Bool = false) : {{ type }}
      if _{{ var }}_preloaded?
        @_preloaded_{{ var }}{% unless nilable %}.not_nil!{% end %}
      elsif lazy_load_enabled? || allow_lazy
        if {{ var }}_type && {{ var }}_id
          case {{ var }}_type
          {% for tn in type.types %}
            {% if tn != Nil %}
              when {{ tn.stringify }} then {{ tn }}::BaseQuery.new.find({{ var }}_id)
            {% end %}
          {% end %}
          else
            raise Avram::LazyLoadError.new {{ @type.name.stringify }}, {{ var.stringify }}
          end
        else
          raise Avram::LazyLoadError.new {{ @type.name.stringify }}, {{ var.stringify }}
        end
      else
        raise Avram::LazyLoadError.new {{ @type.name.stringify }}, {{ var.stringify }}
      end
    end

    # Based on avram/src/avram/associations.cr, define_public_preloaded_getters
    def {{ var }}! : {{ type }}
      get_{{ var }}(allow_lazy: true)
    end

    def {{ var }} : {{ type }}
      get_{{ var }}
    end

    @_{{ var }}_preloaded : Bool = false
    getter? _{{ var }}_preloaded
    getter _preloaded_{{ var }} : {{ type }} | Nil

    def set_preloaded_{{ var }}(record : {{ type }} | Nil)
      @_{{ var }}_preloaded = true
      @_preloaded_{{ var }} = record
    end

    class BaseQuery < Avram::Query
      def preload_{{ var }}
        add_preload do |records|
          ids = Hash(String, Array(Int32)).new { |hash, key| hash[key] = [] of Int32 }
          records.each do |record|
            if record.{{ var }}_type && record.{{ var }}_id
              ids[record.{{ var }}_type] << record.{{ var }}_id
            end
          end
          preload_query = Hash(String, Avram::Query).new
          values = Hash(String, Hash(Int32, {{ type }})).new
          {% for tn in type.types %}
            preload_query[{{ tn.stringify }}] = {{ tn }}::BaseQuery.new.id.in(ids[{{ tn.stringify }}])
            values[{{ tn.stringify }}] = preload_query[{{ tn.stringify }}].results.group_by(&.id)
          {% end %}
          records.each do |record|
            if (id = record.{{ var }}_id)
              record.set_preloaded_{{ var }} values[record.{{ var }}_type][id]?.try(&.first?)
            else
              record.set_preloaded_{{ var }} nil
            end
          end
        end
        self
      end
    end

    # end of macro polymorphic
  end

  macro default(hash)
    #{#% DEFAULT_VALUES.merge!(hash) %}
    {% for field, value in hash %}
      DEFAULT_VALUES[{{field}}] = {{value}}
    {% end %}
  end

  macro setup_db_mapping
    DB.mapping({
      {% for field in FIELDS %}
        {{field[:name]}}: {
          {% if field[:type] == Float64.id %}
            type: PG::Numeric,
            convertor: Float64Convertor,
          {% else %}
            type: {{field[:type]}}::Lucky::ColumnType,
            default: DEFAULT_VALUES[:{{field[:name]}}].as({{field[:type]}}),
          {% end %}
          nilable: {{field[:nilable]}},
        },
      {% end %}
    })
  end
end
