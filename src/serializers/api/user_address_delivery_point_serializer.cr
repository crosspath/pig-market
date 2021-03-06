class Api::UserAddressDeliveryPointSerializer < BaseSerializer
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
      items = Api::UserOrderSerializer.for_collection(@orders.not_nil!)
      res[:user_orders] = items
    end

    res
  end
end
