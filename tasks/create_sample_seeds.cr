require "../spec/support/boxes/**"
require "../spec/support/data_generator.cr"

# Add sample data helpful for development, e.g. (fake users, blog posts, etc.)
#
# Use `Db::CreateRequiredSeeds` if you need to create data *required* for your
# app to work.
class Db::CreateSampleSeeds < LuckyCli::Task
  summary "Add sample database records helpful for development"

  def call
    category_ids   = [] of Int32
    category_path1 = [] of String
    category_path2 = [] of String
    unit_ids       = [] of Int32
    good_ids       = [] of Int32
    user_ids       = [] of Int32
    accounts_hash  = Hash(Int32, Array(Int32)).new # user_id => [account_id]
    user_dp_hash   = Hash(Int32, Array(Int32)).new # user_id => [delivery_point_id]
    store_ids      = [] of Int32
    store_dp_ids   = [] of Int32

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
          "birth_date" => bd ? bd.to_rfc3339 : ""
        }

        user = nil
        UserForm.create(user_params) do |form, new_user|
          if new_user
            user_ids << new_user.id
            user = new_user
          end
        end

        if user && !DataGenerator.shot?
          user_id = user.as(User).id
          bonuses = DataGenerator.true? ? 0 : 100
          count_of_accounts = DataGenerator.true? ? 1 : 2

          boxes = count_of_accounts.times.map do
            BonusAccountBox.create &.user_id(user_id).amount(bonuses.to_i16)
          end

          accounts_hash[user_id] = boxes.map { |x| x.id }.to_a
        end
      end

      if user_ids.empty? || accounts_hash.empty?
        puts "Unexpected behaviour: no users created"
        break
      end

      puts "Creating user addresses"
      20.times do
        user_id = user_ids.sample

        address = AddressBox.create do |a|
          z = 4.times.map { DataGenerator.name }.to_a
          h = DataGenerator.true?

          a.city(z[0]).street(z[1]).building(z[2]).additional(z[3]).hidden(h)
              .recipient_id(user_id).recipient_type("User")
        end

        user_dp_hash[user_id] ||= [] of Int32
        user_dp_hash[user_id] << address.id
      end

      if user_dp_hash.empty?
        puts "Unexpected behaviour: no user addresses created"
        break
      end

      puts "Creating stores"
      12.times do
        store = StoreBox.create do |a|
          t = (DataGenerator.true? ? 0 : 1).to_i16

          a.type(t).name(DataGenerator.name)
        end
        store_ids << store.id

        (DataGenerator.shot? ? 2 : 1).times do
          address = AddressBox.create do |a|
            z = 4.times.map { DataGenerator.name }.to_a
            h = DataGenerator.true?

            a.city(z[0]).street(z[1]).building(z[2]).additional(z[3]).hidden(h)
                .recipient_id(store.id).recipient_type("Store")
          end
          
          store_dp_ids << address.id
        end
      end

      if store_ids.empty? || store_dp_ids.empty?
        puts "Unexpected behaviour: no stores created"
        break
      end

      puts "Creating orders"
      24.times do
        for_user = DataGenerator.true?

        if for_user
          user_id = user_dp_hash.keys.sample
          dp = user_dp_hash[user_id].sample
        else
          user_id = nil
          dp = store_dp_ids.sample
        end

        select_good_ids = DataGenerator.count.times.map { good_ids.sample }.to_a
        goods = GoodQuery.new.id.in(select_good_ids)
        total_cost = goods.reduce(0.0) { |acc, el| acc + el.price }
        total_weight = goods.reduce(0.0) { |acc, el| acc + el.weight }

        order = OrderBox.create do |a|
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

          a.address_id(dp).planned_delivery_date(planned_date)
              .delivered_at(actual_ts)
              .total_cost(total_cost).total_weight(total_weight)
              .planned_delivery_time_interval(planned_time)
        end

        goods.each do |good|
          OrderItemBox.create do |a|
            s = DataGenerator.true? ? store_ids.sample : nil
            g = DataGenerator.shot? ? nil : good.id
            pr = DataGenerator.shot? ? good.price - 0.3 : good.price
            am = DataGenerator.count.to_i16
            wm = DataGenerator.price
            w = am * good.weight * (wm - wm.floor + 0.8)

            a.order_id(order.id).store_id(s).good_id(g).price(pr)
                .weight_of_packaged_items(w).amount(am)
          end
        end

        if for_user && accounts_hash.has_key?(user_id)
          s = DataGenerator.true? ? 0 : 1

          ba = accounts_hash[user_id].sample
          am = DataGenerator.true? ? order.bonus_amount : 0
          account = BonusAccountQuery.new.find(ba)

          if am == 0
            loop do
              am = DataGenerator.count - 2
              break if account.amount + am >= 0 && am != 0
            end
          end

          BonusChangeBox.create do |a|
            a.bonus_account_id(ba).order_id(order.id).change(am.to_i16).state(s.to_i16)
          end

          if s == 1 # activated
            account_params = {"amount" => (account.amount + am).to_s}

            BonusAccountForm.update(account, account_params) do |f, b|
              raise "Not updated: BonusAccountForm, #{ba}" unless b
            end
          end
        end
      end
      
      puts "Creating rejected bonuses"
      5.times do
        user_id = accounts_hash.keys.sample
        ba = accounts_hash[user_id].sample

        BonusChangeBox.create do |a|
          am = (DataGenerator.count - 2).to_i16
          a.bonus_account_id(ba).order_id(nil).change(am).state(2)
        end
      end

      puts "Creating goods in stores"
      30.times do
        GoodsInStoreBox.create do |a|
          a.good_id(good_ids.sample).store_id(store_ids.sample)
              .amount(DataGenerator.count.to_i16)
        end
      end

      true
      # Crystal compiler expects that `transaction` will return Bool,
      # not Bool or nil
    end

    puts "Done adding sample data"
  end
end
