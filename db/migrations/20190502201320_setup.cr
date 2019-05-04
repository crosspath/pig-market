class Setup::V20190502201320 < Avram::Migrator::Migration::V1
  def migrate
    # `create` always includes columns for `id` & timestamps
    # NOTE: models have column with type Float64 while migration declares Float.

    create Category::TABLE_NAME do
      add path : String, index: true, default: "" # Materialised Path
      add name : String
      add description : String, default: ""
    end

    create Unit::TABLE_NAME do
      add name : String
    end

    create Good::TABLE_NAME do
      add name : String
      add_belongs_to unit : Unit?, on_delete: :nullify
      add description : String, default: ""
      add price : Float
      add weight : Float
    end

    create GoodsCategory::TABLE_NAME do
      add_belongs_to good : Good, on_delete: :cascade
      add_belongs_to category : Category, on_delete: :cascade
    end

    create User::TABLE_NAME do
      add login : String, unique: true
      add crypted_password : String
      add first_name : String, default: ""
      add last_name : String, default: ""
      add full_name : String, default: ""
      add birth_date : Date?
    end

    create BonusAccount::TABLE_NAME do
      add_belongs_to user : User, on_delete: :cascade
      add amount : Int16, default: 0
    end

    create Address::TABLE_NAME do
      add city : String, index: true
      add street : String, default: ""
      add building : String, default: ""
      add additional : String, default: ""
    end

    create UsersAddress::TABLE_NAME do
      add_belongs_to user : User, on_delete: :cascade
      add_belongs_to address : Address, on_delete: :cascade
      add hidden : Bool, default: false
    end

    create Store::TABLE_NAME do
      add type : Int16, default: 0 # Enum: [0: shop, 1: storehouse|depot]
      add name : String
      add_belongs_to address : Address, on_delete: :cascade
    end

    create DeliveryPoint::TABLE_NAME do
      # polymorphic: UsersAddress or Store
      add point_type : String
      add point_id : Int32
    end

    create Order::TABLE_NAME do
      add_belongs_to delivery_point : DeliveryPoint, on_delete: :restrict
      add planned_delivery_date : Date?, index: true
      add delivered_at : Time?, index: true
      add total_cost : Float
      add total_weight : Float
      # Enum: [0: 08:00-12:00, 1: 10:00-18:00, 2: 18:00-22:00];
      # used only for deliveries to users
      add planned_delivery_time_interval : Int16?, index: true
    end

    create OrderItem::TABLE_NAME do
      # Before deleting an order all its items should be removed
      add_belongs_to order : Order, on_delete: :restrict
      add_belongs_to from_store : Store?, on_delete: :nullify
      add_belongs_to good : Good?, on_delete: :nullify
      add price : Float
      add weight_of_packaged_items : Float
      add amount : Int16, default: 1
    end

    create GoodsInStore::TABLE_NAME do
      add_belongs_to good : Good, on_delete: :cascade
      add_belongs_to store : Store, on_delete: :cascade
      add amount : Int16, default: 1
    end

    create BonusChange::TABLE_NAME do
      add_belongs_to bonus_account : BonusAccount, on_delete: :cascade
      # Activated bonus should be rejected and order_id should be nullified
      # before deleting this order
      add_belongs_to order : Order?, on_delete: :restrict
      add change : Int16 # N or -N, where N is a number
      add state : Int16, default: 0 # Enum: [0: created, 1: activated, 2: rejected]
    end
  end

  def rollback
    [
      BonusChange::TABLE_NAME,
      GoodsInStore::TABLE_NAME,
      OrderItem::TABLE_NAME,
      Order::TABLE_NAME,
      DeliveryPoint::TABLE_NAME,
      Store::TABLE_NAME,
      UsersAddress::TABLE_NAME,
      Address::TABLE_NAME,
      BonusAccount::TABLE_NAME,
      User::TABLE_NAME,
      GoodsCategory::TABLE_NAME,
      Good::TABLE_NAME,
      Unit::TABLE_NAME,
      Category::TABLE_NAME
    ].each do |table|
      drop table
    end
  end
end
