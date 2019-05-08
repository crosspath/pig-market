class Api::UserSerializer < Lucky::Serializer
  def initialize(@user : User, @orders : Array(Order) | OrderQuery); end

  def render
    ba = @user.bonus_account
    ad = @user.addresses

    {
      id: @user.id,
      login: @user.login,
      first_name: @user.first_name,
      last_name: @user.last_name,
      full_name: @user.full_name,
      birth_date: @user.birth_date,
      bonus_account: ba ? {
        amount: ba.amount
      } : nil,
      addresses: ad.map do |a|
        Api::AddressSerializer.new(a)
      end,
      orders: Api::OrdersSerializer.new(@orders)
    }
  end
end
