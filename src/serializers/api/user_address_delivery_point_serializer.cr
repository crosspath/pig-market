class Api::UserAddressDeliveryPointSerializer < Lucky::Serializer
  alias ResultValue = Int32 | String | Bool | Api::AddressSerializer | Api::UserSerializer
      | Api::UserOrdersSerializer

  def initialize(
    @dp : UserAddressDeliveryPoint,
    @address : Address | Nil = nil,
    @user : User | Nil = nil,
    @orders : Array(UserOrder) | UserOrderQuery | Nil = nil
  ); end

  def render
    res = Hash(Symbol, ResultValue){
      id: u.id,
      hidden: u.hidden,
      address_notes: u.address_notes
    }

    if @address
      res[:address] = Api::AddressSerializer.new(@address)
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
