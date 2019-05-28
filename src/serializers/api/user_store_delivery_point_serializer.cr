class Api::UserStoreDeliveryPointSerializer < Lucky::Serializer
  alias ResultValue = Int32 | Bool | Api::StoreSerializer | Api::UserSerializer
      | Api::UserOrdersSerializer

  def initialize(
    @dp : UserStoreDeliveryPoint,
    @store : Store | Nil = nil,
    @address : Address | Nil = nil,
    @user : User | Nil = nil,
    @orders : Array(UserOrder) | UserOrderQuery | Nil = nil
  ); end

  def render
    res = Hash(Symbol, ResultValue){
      id: u.id,
      hidden: u.hidden
    }

    if @store
      res[:store] = Api::StoreSerializer.new(@store, @address)
    end

    if @user
      res[:user] = Api::UserSerializer.new(@user)
    end

    if @orders
      res[:user_orders] = Api::UserOrdersSerializer.new(@orders)
    end

    res
  end
end
