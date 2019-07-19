class Setup::V20190502201320 < Avram::Migrator::Migration::V1
  def migrate
    # NOTE: models have column with type Float64 while migration declares Float.
    #
    # BUG in Avram: declaration of Primary Key here is a declaration of a column +AND+
    # a sequence, but it should be separate commands or more explicit, like:
    #     primary_key id : PG::Serial
    # Because for has_one associations id column +HAS+ integer type, but +HAS NOT+ a sequence.

    create Category::TABLE_NAME do
      primary_key id : Int32
      add_timestamps
      add path : String, index: true, default: "" # Materialised Path
      add name : String
      add description : String, default: ""
    end

    create Unit::TABLE_NAME do
      primary_key id : Int32
      add_timestamps
      add name : String
    end

    create Good::TABLE_NAME do
      primary_key id : Int32
      add_timestamps
      add name : String
      add_belongs_to unit : Unit?, on_delete: :nullify, foreign_key_type: Int32
      add description : String, default: ""
      add price : Float
      add weight : Float
    end

    %w[price weight].each do |field|
      add_check_gteq(Good::TABLE_NAME, field)
    end

    create GoodsCategory::TABLE_NAME do
      primary_key id : Int32
      add_timestamps
      add_belongs_to good : Good, on_delete: :cascade, foreign_key_type: Int32
      add_belongs_to category : Category, on_delete: :cascade, foreign_key_type: Int32
    end

    create User::TABLE_NAME do
      primary_key id : Int32
      add_timestamps
      add login : String, unique: true
      add crypted_password : String
      add first_name : String, default: ""
      add last_name : String, default: ""
      add full_name : String, default: ""
      add birth_date : Date?
      add bonuses : Int16, default: 0
      add role : Int16, default: 0 # Enum: [0: customer, 1: worker]
    end

    %w[bonuses role].each do |field|
      add_check_gteq(User::TABLE_NAME, field)
    end

    create Address::TABLE_NAME do
      primary_key id : Int32
      add_timestamps
      add city : String, index: true
      add street : String, default: ""
      add building : String, default: ""
    end

    create Store::TABLE_NAME do
      primary_key id : Int32
      add_timestamps
      add type : Int16, default: 0 # Enum: [0: shop, 1: storehouse|depot]
      add name : String
      add_belongs_to address : Address, on_delete: :restrict, foreign_key_type: Int32
      add address_notes : String, default: ""
    end

    add_check_gteq(Store::TABLE_NAME, "type")

    create GoodsInStore::TABLE_NAME do
      primary_key id : Int32
      add_timestamps
      add_belongs_to good : Good, on_delete: :cascade, foreign_key_type: Int32
      add_belongs_to store : Store, on_delete: :cascade, foreign_key_type: Int32
      add amount : Int16, default: 1
    end

    add_check_gteq(GoodsInStore::TABLE_NAME, "amount", 1)

    create StoreOrder::TABLE_NAME do
      primary_key id : Int32
      add_timestamps
      add_belongs_to user : User, on_delete: :restrict, foreign_key_type: Int32
      add_belongs_to store : Store, on_delete: :restrict, foreign_key_type: Int32
      add planned_delivery_date : Date?, index: true
      add delivered_at : Time?, index: true
      add total_cost : Float
      add total_weight : Float
    end

    %w[total_cost total_weight].each do |field|
      add_check_gteq(StoreOrder::TABLE_NAME, field)
    end

    create UserOrder::TABLE_NAME do
      primary_key id : Int32
      add_timestamps
      # Polymorphic: UserStoreDeliveryPoint, UserAddressDeliveryPoint
      add delivery_point_type : String
      add delivery_point_id : Int32
      add planned_delivery_date : Date?, index: true
      add delivered_at : Time?, index: true
      add total_cost : Float
      add total_weight : Float
      # Enum: [0: 08:00-12:00, 1: 10:00-18:00, 2: 18:00-22:00]
      add planned_delivery_time_interval : Int16?, index: true
      add used_bonuses : Int16, default: 0
      # Activated bonus should be rejected before deleting this order
      add earned_bonuses : Int16 # Should be >= 0
      # Enum: [0: created, 1: activated, 2: rejected]
      add earned_bonuses_state : Int16, default: 0
    end

    t = [UserStoreDeliveryPoint, UserAddressDeliveryPoint].map { |x| "'#{x.name}'" }.join(", ")
    execute "ALTER TABLE #{UserOrder::TABLE_NAME} ADD CHECK (delivery_point_type IN (#{t}))"

    field = "planned_delivery_time_interval"
    execute "ALTER TABLE #{UserOrder::TABLE_NAME} ADD CHECK (#{field} IS NULL OR #{field} >= 0)"

    %w[total_cost total_weight used_bonuses earned_bonuses earned_bonuses_state].each do |field|
      add_check_gteq(UserOrder::TABLE_NAME, field)
    end

    create OrderItem::TABLE_NAME do
      primary_key id : Int32
      add_timestamps
      # Before deleting an order all its items should be removed
      # Polymorphic: StoreOrder, UserOrder
      add order_type : String
      add order_id : Int32
      add_belongs_to store : Store?, on_delete: :nullify, foreign_key_type: Int32
      add_belongs_to good : Good?, on_delete: :nullify, foreign_key_type: Int32
      add price : Float
      add weight_of_packaged_items : Float
      add amount : Int16, default: 1
    end

    t = [StoreOrder, UserOrder].map { |x| "'#{x.name}'" }.join(", ")
    execute "ALTER TABLE #{OrderItem::TABLE_NAME} ADD CHECK (order_type IN (#{t}))"

    %w[price weight_of_packaged_items].each do |field|
      add_check_gteq(OrderItem::TABLE_NAME, field)
    end

    add_check_gteq(OrderItem::TABLE_NAME, "amount", 1)

    create UserStoreDeliveryPoint::TABLE_NAME do
      primary_key id : Int32
      add_timestamps
      add_belongs_to user : User, on_delete: :cascade, foreign_key_type: Int32
      add_belongs_to store : Store, on_delete: :cascade, foreign_key_type: Int32
      add hidden : Bool, default: false
    end

    create UserAddressDeliveryPoint::TABLE_NAME do
      primary_key id : Int32
      add_timestamps
      add_belongs_to user : User, on_delete: :cascade, foreign_key_type: Int32
      add_belongs_to address : Address, on_delete: :cascade, foreign_key_type: Int32
      add address_notes : String, default: ""
      add hidden : Bool, default: false
    end
  end

  def rollback
    [
      UserAddressDeliveryPoint::TABLE_NAME,
      UserStoreDeliveryPoint::TABLE_NAME,
      OrderItem::TABLE_NAME,
      UserOrder::TABLE_NAME,
      StoreOrder::TABLE_NAME,
      GoodsInStore::TABLE_NAME,
      Store::TABLE_NAME,
      Address::TABLE_NAME,
      User::TABLE_NAME,
      GoodsCategory::TABLE_NAME,
      Good::TABLE_NAME,
      Unit::TABLE_NAME,
      Category::TABLE_NAME
    ].each do |table|
      drop table
    end
  end

  def add_check_gteq(table, field, value = 0)
    execute "ALTER TABLE #{table} ADD CHECK (#{field} >= #{value})"
  end
end
