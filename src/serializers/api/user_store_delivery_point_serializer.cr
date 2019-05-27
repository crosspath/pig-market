class Api::UserStoreDeliveryPointSerializer < Lucky::Serializer
  def initialize(
    @dp : UserStoreDeliveryPoint,
    @with_orders : Bool = true,
    @with_store : Bool = true
  ); end

  def render
    res = {
      id: u.id,
      type: "UserStoreDeliveryPoint",
      user_id: u.user_id,
      hidden: u.hidden
    }
    if @with_store
      store = @dp.store
      res[:store] = store ? Api::StoreSerializer.new(store, goods: nil) : nil
    end
    if @with_orders
      raise "Not implemented" # TODO
    end

    res
  end
end
