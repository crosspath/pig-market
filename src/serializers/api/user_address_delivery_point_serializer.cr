class Api::UserAddressDeliveryPointSerializer < Lucky::Serializer
  alias ResultValue = Int32 | String | Bool | Lucky::Serializer

  def initialize(
    @dp : UserAddressDeliveryPoint,
    @address : Address | Nil = nil,
    @user : User | Nil = nil,
    @orders : Array(UserOrder) | UserOrderQuery | Nil = nil
  ); end

  def render
    res = Hash(Symbol, ResultValue){
      :id => @dp.id,
      :hidden => @dp.hidden,
      :address_notes => @dp.address_notes
    }

    if @address
      res[:address] = Api::AddressSerializer.new(@address.not_nil!)
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
