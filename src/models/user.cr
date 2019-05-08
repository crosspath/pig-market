class User < BaseModel
  table :users do
    has_one bonus_account : BonusAccount?

    column login : String
    column crypted_password : String
    column first_name : String
    column last_name : String
    column full_name : String
    column birth_date : Time? # Only date

    default({:first_name => "", :last_name => "", :full_name => ""})
  end

  # Code below based on avram/associations.cr

  @_preloaded_addresses : Array(Address)?

  setter _preloaded_addresses

  def addresses : Array(Address)
    a = @_preloaded_addresses || maybe_lazy_load_addresses
    if a
      a
    else
      raise Avram::LazyLoadError.new {{ @type.name.stringify }}, "addresses"
    end
  end

  def addresses! : Array(Address)
    @_preloaded_addresses || lazy_load_addresses
  end

  private def maybe_lazy_load_addresses : Array(Address)?
    lazy_load_addresses if lazy_load_enabled?
  end

  private def lazy_load_addresses : Array(Address)
    query = Address::BaseQuery.new
    query = query.recipient_id(id).recipient_type({{ @type.name.stringify }})
    query.results
  end

  class BaseQuery < Avram::Query
    def preload_addresses
      preload_addresses(Address::BaseQuery.new)
    end

    def preload_addresses(preload_query : Address::BaseQuery)
      add_preload do |records|
        ids = records.map(&.id)
        query = preload_query.dup.recipient_id.in(ids).recipient_type("User")
        addresses = query.results.group_by(&.recipient_id)
        records.each do |record|
          record._preloaded_addresses = addresses[record.id]? || [] of Address
        end
      end
      self
    end
    
    def join_addresses
      inner_join_addresses
    end

    {% for join_type in ["Inner", "Left"] %}
      def {{ join_type.downcase.id }}_join_addresses
        join(
          PolymorphicJoin::{{ join_type.id }}.new(
            @@table_name,
            :addresses,
            polymorphic_type: :recipient,
            polymorphic_value: "User"
          )
        )
      end
    {% end %} #}

    def addresses
      Address::BaseQuery.new_with_existing_query(query).tap do |assoc_query|
        yield assoc_query
      end
      self
    end
  end
end
