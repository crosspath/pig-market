class Api::UserStoreDeliveryPointSerializer < Lucky::Serializer
  alias ResultValue = Int32 | Bool | Lucky::Serializer

  def initialize(
    @dp : UserStoreDeliveryPoint,
    @store : Store | Nil = nil,
    @address : Address | Nil = nil,
    @user : User | Nil = nil,
    @orders : Array(UserOrder) | UserOrderQuery | Nil = nil
  ); end

  def render
    res = Hash(Symbol, ResultValue){
      :id => @dp.id,
      :hidden => @dp.hidden
    }

    if @store
      res[:store] = Api::StoreSerializer.new(@store.not_nil!, @address)
    end

    if @user
      res[:user] = Api::UserSerializer.new(@user.not_nil!)
    end

    if @orders
      res[:user_orders] = Api::UserOrdersSerializer.new(@orders.not_nil!)
    end

    res
  end
end
