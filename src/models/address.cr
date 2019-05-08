class Address < BaseModel
  table :addresses do
    has_many orders : Order

    column recipient_type : String
    column recipient_id : Int32
    column city : String
    column street : String
    column building : String
    column additional : String
    column hidden : Bool

    default({:street => "", :building => "", :additional => ""})
  end

  # Code below based on avram/associations.cr

  @_recipient_preloaded : Bool = false

  getter? _recipient_preloaded
  getter _preloaded_recipient : User | Store | Nil

  private def get_recipient(allow_lazy : Bool = false) : User | Store
    if _recipient_preloaded?
      @_preloaded_recipient.not_nil!
    elsif lazy_load_enabled? || allow_lazy
      if recipient_id
        case recipient_type
        when "User" then User::BaseQuery.new.find(recipient_id)
        when "Store" then Store::BaseQuery.new.find(recipient_id)
        else
          raise Avram::LazyLoadError.new {{ @type.name.stringify }}, "recipient"
        end
      else
        nil
      end
    else
      raise Avram::LazyLoadError.new {{ @type.name.stringify }}, "recipient"
    end
  end

  def recipient! : User | Store
    get_recipient(allow_lazy: true)
  end

  def recipient : User | Store
    get_recipient
  end

  def set_preloaded_recipient(record : User | Store | Nil)
    @_recipient_preloaded = true
    @_preloaded_recipient = record
  end

  class BaseQuery < Avram::Query
    def preload_recipient(preload_query : User::BaseQuery | Store::BaseQuery | Nil = nil)
      add_preload do |records|
        ids = Hash(Symbol, Array(PRIMARY_KEY_TYPE_CLASS))
        ids[:user]  = [] of PRIMARY_KEY_TYPE_CLASS
        ids[:store] = [] of PRIMARY_KEY_TYPE_CLASS

        records.each do |record|
          if record.recipient_id
            case record.recipient_type
            when "User" then ids[:user] << record.recipient_id
            when "Store" then ids[:store] << record.recipient_id
            else
              type = record.recipient_type.inspect
              raise "Unexpected recipient_type: #{type}. Record: #{record.inspect}."
            end
          end
        end

        if preload_query
          preload_queries = [preload_query.dup]
        else
          preload_queries = [User::BaseQuery.new, Store::BaseQuery.new]
        end

        preload_queries.each do |query|
          selected_ids = query.is_a?(User::BaseQuery) ? ids[:user] : ids[:store]
          recipient = query.id.in(selected_ids).results.group_by(&.id)
          records.each do |record|
            if (id = record.recipient_id)
              record.set_preloaded_recipient recipient[id]?.try(&.first?)
            else
              record.set_preloaded_recipient nil
            end
          end
        end
      end

      self
    end

    {% for assoc in ["user", "store"] %}
      def join_{{ assoc.id }}
        inner_join_{{ assoc.id }}
      end

      {% for join_type in ["Inner", "Left"] %}
        def {{ join_type.downcase.id }}_join_{{ assoc.id }}
          join(
            PolymorphicJoinBelongs::{{ join_type.id }}.new(
              @@table_name,
              :{{ assoc.id }},
              polymorphic_type: :recipient,
              polymorphic_value: "User"
            )
          )
        end
      {% end %}
    {% end %}

    def user
      User::BaseQuery.new_with_existing_query(query).tap do |assoc_query|
        yield assoc_query
      end
      self
    end

    def store
      Store::BaseQuery.new_with_existing_query(query).tap do |assoc_query|
        yield assoc_query
      end
      self
    end
  end
end
