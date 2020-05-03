require "../spec/support/boxes/**"
require "../spec/support/data_generator.cr"

# Add sample data helpful for development, e.g. (fake users, blog posts, etc.)
#
# Use `Db::CreateRequiredSeeds` if you need to create data *required* for your
# app to work.
class Db::CreateSampleSeeds < LuckyCli::Task
  summary "Add sample database records helpful for development"

  private def create_categories
    category_ids   = [] of Int32
    category_path1 = [] of String
    category_path2 = [] of String

    10.times do
      category = CategoryBox.create do |a|
        path = case DataGenerator.count
        when 0..1
          ""
        when 2..3
          category_path1.empty? ? "" : category_path1.sample
        else
          category_path2.empty? ? "" : category_path2.sample
        end
        a.path(path).name(DataGenerator.name).description(DataGenerator.text)
      end

      if category.path.empty?
        category_path1 << category.child_path
      else
        category_path2 << category.child_path
      end

      category_ids << category.id
    end

    category_ids
  end

  private def create_units
    unit_ids = [] of Int32

    10.times do
      unit = UnitBox.create &.name(DataGenerator.unit_name)
      unit_ids << unit.id
    end

    unit_ids
  end

  private def create_goods(category_ids, unit_ids)
    good_ids = [] of Int32

    30.times do
      good = GoodBox.create do |a|
        u = DataGenerator.shot? ? nil : unit_ids.sample
        a.unit_id(u).name(DataGenerator.name).description(DataGenerator.text)
            .price(DataGenerator.price).weight(DataGenerator.price)
      end
      good_ids << good.id

      unless DataGenerator.shot?
        DataGenerator.count.times do
          GoodsCategoryBox.create do |a|
            a.good_id(good.id).category_id(category_ids.sample)
          end
        end
      end
    end

    good_ids
  end

  private def create_users
    customer_ids = [] of Int32
    worker_ids   = [] of Int32

    10.times do
      login = ""
      loop do
        uq = UserQuery.new # Should be in loop, because `uq.login` adds new value on each call
        login = DataGenerator.unit_name
        break if uq.login(login).select_count == 0
      end

      z = [DataGenerator.count, 2].max.times.map { DataGenerator.name }.to_a
      bd = DataGenerator.true? ? nil : Time.utc.shift(days: DataGenerator.count * 20)

      # Cannot use UserBox, because `password` is a virtual field in UserForm,
      # that is not available in User::BaseForm (used by UserBox < Avram::Box).
      # Also, instantiating UserForm in UserBox crashes Crystal:
      #
      # Invalid memory access (signal 11) at address 0x0
      # [0x5645407f4f16] *CallStack::print_backtrace:Int32 +118
      # [0x5645407c0360] __crystal_sigfault_handler +192
      # [0x7f5b06c93dd0] ???
      # [0x5645407aaca0] __crystal_main +24384
      # [0x564540a69a49] *Crystal::main_user_code<Int32, Pointer(Pointer(UInt8))>:Nil +9
      # [0x564540a699a9] *Crystal::main<Int32, Pointer(Pointer(UInt8))>:Int32 +41
      # [0x5645407b7076] main +6
      # [0x7f5b0684a09b] __libc_start_main +235
      # [0x5645407a4c9a] _start +42
      # [0x0] ???
      #
      # This problem relates to representing @@fillable_param_keys in Avram::Form

      user_params = {
        "login"      => login,
        "password"   => DataGenerator.password,
        "first_name" => z.first,
        "last_name"  => z.last,
        "full_name"  => z.join(" "),
        "birth_date" => bd ? bd.to_rfc3339 : "",
        "role"       => DataGenerator.true? ? "0": "1",
        "bonuses"    => DataGenerator.shot? ? "100" : "0"
      }
      user = nil
      UserForm.create(user_params) do |form, new_user|
        user = new_user
      end

      if user
        if user.role == 0
          customer_ids << user.id
        else
          worker_ids << user.id
        end
      end
    end

    {customer_ids, worker_ids}
  end

  private def create_addresses
    address_ids = [] of Int32

    20.times do
      address = AddressBox.create do |a|
        z = 3.times.map { DataGenerator.name }.to_a

        a.city(z[0]).street(z[1]).building(z[2])
      end

      address_ids << address.id
    end

    address_ids
  end

  private def create_stores(address_ids)
    store_ids = [] of Int32

    12.times do
      store = StoreBox.create do |a|
        t = (DataGenerator.true? ? 0 : 1).to_i16

        a.type(t).name(DataGenerator.name)
            .address_id(address_ids.sample).address_notes(DataGenerator.name)
      end
      store_ids << store.id
    end

    store_ids
  end

  private def create_goods_in_stores(good_ids, store_ids)
    30.times do
      GoodsInStoreBox.create do |a|
        a.good_id(good_ids.sample).store_id(store_ids.sample)
            .amount(DataGenerator.count.to_i16)
      end
    end
  end

  private def find_or_create_delivery_point(user_id, user_d_points, store_ids, address_ids)
    dp_type = ""
    dp_id   = 0

    if user_d_points[user_id].empty? || DataGenerator.true?
      dp = if DataGenerator.true?
        UserStoreDeliveryPointBox.create do |q|
          q.user_id(user_id).store_id(store_ids.sample).hidden(DataGenerator.true?)
        end
      else
        UserAddressDeliveryPointBox.create do |q|
          q.user_id(user_id).address_id(address_ids.sample)
              .address_notes(DataGenerator.name).hidden(DataGenerator.true?)
        end
      end
      dp_type = dp.class.name
      dp_id   = dp.id

      user_d_points[user_id] << {dp_type, dp_id}
    else
      dp_type, dp_id = user_d_points[user_id].sample
    end

    {dp_type, dp_id}
  end

  private def create_user_order(customer_ids, goods, user_d_points, store_ids, address_ids)
    user_id = customer_ids.sample
    user = UserQuery.find(user_id)

    total_cost = goods.reduce(0.0) { |acc, el| acc + el.price }
    total_weight = goods.reduce(0.0) { |acc, el| acc + el.weight }

    order = UserOrderBox.create do |a|
      planned_date = if DataGenerator.shot?
        nil
      else
        Time.utc.shift(days: DataGenerator.count)
      end

      actual_ts = if planned_date && DataGenerator.true?
        planned_date.shift(days: DataGenerator.count - 2)
      else
        nil
      end

      planned_time = planned_date ? DataGenerator.count.to_i16 : nil
      planned_time = nil if planned_time && planned_time > 2

      total_cost += (DataGenerator.count.to_f - 2.0).abs
      total_weight += DataGenerator.count.to_f

      dp_type, dp_id = find_or_create_delivery_point(
        user_id, user_d_points, store_ids, address_ids
      )

      if DataGenerator.shot?
        ub, bs, am = 0.to_i16, 0.to_i16, 0.to_i16
      else
        ub = DataGenerator.true? ? [user.bonuses, DataGenerator.count].max : 0
        ub = [ub, user.bonuses, total_cost].min.to_i16
        bs = (DataGenerator.count % 3).to_i16
        am = UserOrder.bonus_amount(total_cost)
      end

      a.delivery_point_type(dp_type).delivery_point_id(dp_id)
          .planned_delivery_date(planned_date).delivered_at(actual_ts)
          .total_cost(total_cost - ub).total_weight(total_weight)
          .planned_delivery_time_interval(planned_time)
          .used_bonuses(ub).earned_bonuses_state(bs).earned_bonuses(am)
    end

    if order.earned_bonuses_state == 1 || order.used_bonuses > 0
      new_bonuses_amount = user.bonuses
      new_bonuses_amount += order.earned_bonuses if order.earned_bonuses_state == 1
      new_bonuses_amount -= order.used_bonuses

      user_params = {"bonuses" => new_bonuses_amount.to_s}

      UserForm.update(user, user_params) do |f, b|
        raise "Not updated: UserForm, #{user_id}" unless b
      end
    end

    order
  end

  private def create_store_order(worker_ids, goods, store_ids)
    user_id = worker_ids.sample
    total_cost = goods.reduce(0.0) { |acc, el| acc + el.price }
    total_weight = goods.reduce(0.0) { |acc, el| acc + el.weight }
    store = store_ids.sample

    order = StoreOrderBox.create do |a|
      planned_date = if DataGenerator.shot?
        nil
      else
        Time.utc.shift(days: DataGenerator.count)
      end

      actual_ts = if planned_date && DataGenerator.true?
        planned_date.shift(days: DataGenerator.count - 2)
      else
        nil
      end

      total_cost += DataGenerator.count.to_f - 2.0
      total_weight += DataGenerator.count.to_f

      a.store_id(store).user_id(user_id)
          .planned_delivery_date(planned_date).delivered_at(actual_ts)
          .total_cost(total_cost).total_weight(total_weight)
    end

    order
  end

  private def create_order_items(order, goods, store_ids)
    goods.each do |good|
      OrderItemBox.create do |a|
        s = DataGenerator.true? ? store_ids.sample : nil
        g = DataGenerator.shot? ? nil : good.id
        pr = DataGenerator.shot? ? good.price - 0.3 : good.price
        am = DataGenerator.count.to_i16
        wm = DataGenerator.price
        w = am * good.weight * (wm - wm.floor + 0.8)

        a.order_type(order.class.name).order_id(order.id).store_id(s).good_id(g)
            .price(pr).weight_of_packaged_items(w).amount(am)
      end
    end
  end

  def call
    category_ids   = [] of Int32
    unit_ids       = [] of Int32
    good_ids       = [] of Int32
    customer_ids   = [] of Int32
    worker_ids     = [] of Int32
    address_ids    = [] of Int32
    store_ids      = [] of Int32

    user_d_points  = Hash(Int32, Array(Tuple(String, Int32))).new do |hash, key|
      hash[key] = [] of Tuple(String, Int32)
    end

    AppDatabase.transaction do
      puts "Creating categories"
      category_ids = create_categories

      if category_ids.empty?
        puts "Unexpected behaviour: no categories created"
        break
      end

      puts "Creating units"
      unit_ids = create_units

      if unit_ids.empty?
        puts "Unexpected behaviour: no units created"
        break
      end

      puts "Creating goods"
      good_ids = create_goods(category_ids, unit_ids)

      if good_ids.empty?
        puts "Unexpected behaviour: no goods created"
        break
      end

      puts "Creating users"
      customer_ids, worker_ids = create_users

      if customer_ids.empty? && worker_ids.empty?
        puts "Unexpected behaviour: no users created"
        break
      end

      puts "Creating addresses"
      address_ids = create_addresses

      if address_ids.empty?
        puts "Unexpected behaviour: no addresses created"
        break
      end

      puts "Creating stores"
      store_ids = create_stores(address_ids)

      if store_ids.empty?
        puts "Unexpected behaviour: no stores created"
        break
      end

      puts "Creating goods in stores"
      create_goods_in_stores(good_ids, store_ids)

      puts "Creating user orders"
      10.times do
        select_good_ids = DataGenerator.count.times.map { good_ids.sample }.to_a
        goods = GoodQuery.new.id.in(select_good_ids)

        order = create_user_order(customer_ids, goods, user_d_points, store_ids, address_ids)
        create_order_items(order, goods, store_ids)
      end

      puts "Creating store orders"
      10.times do
        select_good_ids = DataGenerator.count.times.map { good_ids.sample }.to_a
        goods = GoodQuery.new.id.in(select_good_ids)

        order = create_store_order(worker_ids, goods, store_ids)
        create_order_items(order, goods, store_ids)
      end

      true
      # Crystal compiler expects that `transaction` will return Bool,
      # not Bool or nil
    end

    puts "Done adding sample data"
  end
end
