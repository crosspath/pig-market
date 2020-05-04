class Avram::Model
  DEFAULT_VALUES = {} of SymbolLiteral => DefaultValueType

  macro default(hash)
    {% for field, value in hash %}
      {% DEFAULT_VALUES[field.symbolize] = value %}
    {% end %}
  end

  macro setup_db_mapping(columns, *args, **named_args)
    DB.mapping({
      {% for column in columns %}
        {{column[:name]}}: {
          {% if column[:type].id == Float64.id %}
            type: PG::Numeric,
            convertor: Float64Convertor,
          {% else %}
            {% if column[:type].is_a?(Generic) %}
            type: {{column[:type]}},
            {% else %}
            type: {{column[:type]}}::Lucky::ColumnType,
            {% end %}
            {% if DEFAULT_VALUES[column[:name].symbolize] != nil %}
              default: {{ DEFAULT_VALUES[column[:name].symbolize] }},
              # BUG: one variable DEFAULT_VALUES is used for all classes based on
              # Avram::Model. Let's clear its value.
              {% DEFAULT_VALUES[column[:name].symbolize] = nil %}
            {% end %}
          {% end %}
          nilable: {{column[:nilable]}},
        },
      {% end %}
    })
  end
end

# BUG in Avram: Avram::Attribute parses "" as nil, it breaks usage of default values
class Avram::Attribute(T)
  def value
    @value
  end
end
