class Setup::V20190502201320 < Avram::Migrator::Migration::V1
  def migrate
    create table_for(Category) do
      primary_key id : Int32
      add_timestamps
      add path : String, index: true, default: "" # Materialised Path
      add name : String
      add description : String, default: ""
    end

    create table_for(Unit) do
      primary_key id : Int32
      add_timestamps
      add name : String
    end

    create table_for(Good) do
      primary_key id : Int32
      add_timestamps
      add name : String
      add_belongs_to unit : Unit?, on_delete: :nullify, foreign_key_type: Int32
      add description : String, default: ""
      add price : Float64
      add weight : Float64
    end

    %w[price weight].each do |field|
      add_check_gteq(table_for(Good), field)
    end

    create table_for(GoodsCategory) do
      primary_key id : Int32
      add_timestamps
      add_belongs_to good : Good, on_delete: :cascade, foreign_key_type: Int32
      add_belongs_to category : Category, on_delete: :cascade, foreign_key_type: Int32
    end

    create table_for(User) do
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
      add_check_gteq(table_for(User), field)
    end

    create table_for(Address) do
      primary_key id : Int32
      add_timestamps
      add city : String, index: true
      add street : String, default: ""
      add building : String, default: ""
    end

    create table_for(Store) do
      primary_key id : Int32
      add_timestamps
      add type : Int16, default: 0 # Enum: [0: shop, 1: storehouse|depot]
      add name : String
      add_belongs_to address : Address, on_delete: :restrict, foreign_key_type: Int32
      add address_notes : String, default: ""
    end

    add_check_gteq(table_for(Store), "type")

    create table_for(GoodsInStore) do
      primary_key id : Int32
      add_timestamps
      add_belongs_to good : Good, on_delete: :cascade, foreign_key_type: Int32
      add_belongs_to store : Store, on_delete: :cascade, foreign_key_type: Int32
      add amount : Int16, default: 1
    end

    add_check_gteq(table_for(GoodsInStore), "amount", 1)

    create table_for(StoreOrder) do
      primary_key id : Int32
      add_timestamps
      add_belongs_to user : User, on_delete: :restrict, foreign_key_type: Int32
      add_belongs_to store : Store, on_delete: :restrict, foreign_key_type: Int32
      add planned_delivery_date : Date?, index: true
      add delivered_at : Time?, index: true
      add total_cost : Float64
      add total_weight : Float64
    end

    %w[total_cost total_weight].each do |field|
      add_check_gteq(table_for(StoreOrder), field)
    end

    create table_for(UserOrder) do
      primary_key id : Int32
      add_timestamps
      # Polymorphic: UserStoreDeliveryPoint, UserAddressDeliveryPoint
      add delivery_point_type : String
      add delivery_point_id : Int32
      add planned_delivery_date : Date?, index: true
      add delivered_at : Time?, index: true
      add total_cost : Float64
      add total_weight : Float64
      # Enum: [0: 08:00-12:00, 1: 10:00-18:00, 2: 18:00-22:00]
      add planned_delivery_time_interval : Int16?, index: true
      add used_bonuses : Int16, default: 0
      # Activated bonus should be rejected before deleting this order
      add earned_bonuses : Int16 # Should be >= 0
      # Enum: [0: created, 1: activated, 2: rejected]
      add earned_bonuses_state : Int16, default: 0
    end

    t = [UserStoreDeliveryPoint, UserAddressDeliveryPoint].map { |x| "'#{x.name}'" }.join(", ")
    execute "ALTER TABLE #{table_for(UserOrder)} ADD CHECK (delivery_point_type IN (#{t}))"

    field = "planned_delivery_time_interval"
    execute "ALTER TABLE #{table_for(UserOrder)} ADD CHECK (#{field} IS NULL OR #{field} >= 0)"

    %w[total_cost total_weight used_bonuses earned_bonuses earned_bonuses_state].each do |field|
      add_check_gteq(table_for(UserOrder), field)
    end

    create table_for(OrderItem) do
      primary_key id : Int32
      add_timestamps
      # Before deleting an order all its items should be removed
      # Polymorphic: StoreOrder, UserOrder
      add order_type : String
      add order_id : Int32
      add_belongs_to store : Store?, on_delete: :nullify, foreign_key_type: Int32
      add_belongs_to good : Good?, on_delete: :nullify, foreign_key_type: Int32
      add price : Float64
      add weight_of_packaged_items : Float64
      add amount : Int16, default: 1
    end

    t = [StoreOrder, UserOrder].map { |x| "'#{x.name}'" }.join(", ")
    execute "ALTER TABLE #{table_for(OrderItem)} ADD CHECK (order_type IN (#{t}))"

    %w[price weight_of_packaged_items].each do |field|
      add_check_gteq(table_for(OrderItem), field)
    end

    add_check_gteq(table_for(OrderItem), "amount", 1)

    create table_for(UserStoreDeliveryPoint) do
      primary_key id : Int32
      add_timestamps
      add_belongs_to user : User, on_delete: :cascade, foreign_key_type: Int32
      add_belongs_to store : Store, on_delete: :cascade, foreign_key_type: Int32
      add hidden : Bool, default: false
    end

    create table_for(UserAddressDeliveryPoint) do
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
      table_for(UserAddressDeliveryPoint),
      table_for(UserStoreDeliveryPoint),
      table_for(OrderItem),
      table_for(UserOrder),
      table_for(StoreOrder),
      table_for(GoodsInStore),
      table_for(Store),
      table_for(Address),
      table_for(User),
      table_for(GoodsCategory),
      table_for(Good),
      table_for(Unit),
      table_for(Category)
    ].each do |table|
      drop table
    end
  end

  def add_check_gteq(table, field, value = 0)
    execute "ALTER TABLE #{table} ADD CHECK (#{field} >= #{value})"
  end
end
