class Avram::Model
  alias DefaultValueType =
      Bool | Float64 | Int16 | Int32 | Int64 | JSON::Any | String | Time | UUID | Nil

  macro polymorphic(name_and_type)
    {% var = name_and_type.var %}
    {% type = name_and_type.type %}
    {% nilable = type.types.includes?(Nil) %}
    column {{ var }}_type : String{% if nilable %}?{% end %}
    column {{ var }}_id : Int32{% if nilable %}?{% end %}
    
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
end
