require "../spec/support/boxes/**"
require "../spec/support/data_generator.cr"

# Add sample data helpful for development, e.g. (fake users, blog posts, etc.)
#
# Use `Db::CreateRequiredSeeds` if you need to create data *required* for your
# app to work.
class Db::CreateSampleSeeds < LuckyCli::Task
  summary "Add sample database records helpful for development"

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
    category_path1 = [] of String
    category_path2 = [] of String
    unit_ids       = [] of Int32
    good_ids       = [] of Int32
    customer_ids   = [] of Int32
    worker_ids     = [] of Int32
    address_ids    = [] of Int32
    store_ids      = [] of Int32

    user_d_points  = Hash(Int32, Array(Tuple(String, Int32))).new do |hash, key|
      hash[key] = [] of Tuple(String, Int32)
    end

    Avram::Repo.transaction do
      puts "Creating categories"
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
      
      if category_ids.empty?
        puts "Unexpected behaviour: no categories created"
        break
      end

      puts "Creating units"
      10.times do
        unit = UnitBox.create &.name(DataGenerator.unit_name)
        unit_ids << unit.id
      end

      if unit_ids.empty?
        puts "Unexpected behaviour: no units created"
        break
      end

      puts "Creating goods"
      30.times do
        good = GoodBox.create do |a|
          u = DataGenerator.shot? ? nil : unit_ids.sample
          a.name(DataGenerator.name)
              .unit_id(u).description(DataGenerator.text)
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

      if good_ids.empty?
        puts "Unexpected behaviour: no goods created"
        break
      end

      puts "Creating users"
      10.times do
        uq = UserQuery.new
        login = ""
        loop do
          login = DataGenerator.unit_name
          break if uq.login(login).select_count == 0
        end

        z = [DataGenerator.count, 2].max.times.map { DataGenerator.name }.to_a
        bd = DataGenerator.true? ? nil : Time.utc.shift(days: DataGenerator.count * 20)

        user_params = {
          "login"      => login,
          "password"   => DataGenerator.password,
          "first_name" => z.first,
          "last_name"  => z.last,
          "full_name"  => z.join(" "),
          "birth_date" => bd ? bd.to_rfc3339 : "",
          "role"       => DataGenerator.true? ? 0 : 1
        }

        user = nil
        UserForm.create(user_params) do |form, new_user|
          if new_user
            if new_user.role.value == 0
              customer_ids << new_user.id
            else
              worker_ids << new_user.id
            end
            user = new_user
          end
        end
      end

      if customer_ids.empty? && worker_ids.empty?
        puts "Unexpected behaviour: no users created"
        break
      end

      puts "Creating addresses"
      20.times do
        address = AddressBox.create do |a|
          z = 3.times.map { DataGenerator.name }.to_a

          a.city(z[0]).street(z[1]).building(z[2])
        end

        address_ids << address.id
      end

      if address_ids.empty?
        puts "Unexpected behaviour: no user addresses created"
        break
      end

      puts "Creating stores"
      12.times do
        store = StoreBox.create do |a|
          t = (DataGenerator.true? ? 0 : 1).to_i16

          a.type(t).name(DataGenerator.name)
              .address_id(address_ids.sample).address_notes(DataGenerator.name)
        end
        store_ids << store.id
      end

      if store_ids.empty?
        puts "Unexpected behaviour: no stores created"
        break
      end

      puts "Creating goods in stores"
      30.times do
        GoodsInStoreBox.create do |a|
          a.good_id(good_ids.sample).store_id(store_ids.sample)
              .amount(DataGenerator.count.to_i16)
        end
      end

      puts "Creating user orders"
      10.times do
        user_id = customer_ids.sample
        select_good_ids = DataGenerator.count.times.map { good_ids.sample }.to_a
        goods = GoodQuery.new.id.in(select_good_ids)
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

          total_cost += DataGenerator.count.to_f - 2.0
          total_weight += DataGenerator.count.to_f

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
                    address_notes(DataGenerator.name).hidden(DataGenerator.true?)
              end
            end
            dp_type = dp.class.name
            dp_id   = dp.id

            user_d_points[user_id] << {dp_type, dp_id}
          else
            dp_type, dp_id = user_d_points[user_id].sample
          end

          if DataGenerator.shot?
            ub = 0
            bc_id = nil
          else
            user = User.find(user_id)
            ub   = DataGenerator.true? ? [user.bonuses, DataGenerator.count].max : 0

            bc = BonusChangeBox.create do |q|
              q.change(UserOrder.bonus_amount(total_cost)).state(DataGenerator.count % 3)
            end
            bc_id = bc.id

            if bc.state.value == 1
              user_params = {"bonuses" => (account.amount + am).to_s}

              UserForm.update(user, user_params) do |f, b|
                raise "Not updated: UserForm, #{user_id}" unless b
              end
            end
          end

          a.delivery_point_type(dp_type).delivery_point_id(dp_id)
              .planned_delivery_date(planned_date).delivered_at(actual_ts)
              .total_cost(total_cost - ub).total_weight(total_weight)
              .planned_delivery_time_interval(planned_time)
              .bonus_change_id(bc_id).used_bonuses(ub)
        end

        create_order_items(order, goods, store_ids)
      end

      puts "Creating store orders"
      10.times do
        user_id = worker_ids.sample
        select_good_ids = DataGenerator.count.times.map { good_ids.sample }.to_a
        goods = GoodQuery.new.id.in(select_good_ids)
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
              .total_cost(total_cost - ub).total_weight(total_weight)
        end

        create_order_items(order, goods, store_ids)
      end

      true
      # Crystal compiler expects that `transaction` will return Bool,
      # not Bool or nil
    end

    puts "Done adding sample data"
  end
end
