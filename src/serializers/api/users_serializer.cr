class Api::UsersSerializer < Lucky::Serializer
  def initialize(@users : Array(User) | UserQuery); end

  def render
    @users.map do |u|
      ba = u.bonus_account
      ad = u.addresses

      {
        id: u.id,
        login: u.login,
        first_name: u.first_name,
        last_name: u.last_name,
        full_name: u.full_name,
        birth_date: u.birth_date,
        bonus_account: ba ? {
          amount: ba.amount
        } : nil,
        addresses: ad.map do |a|
          Api::AddressSerializer.new(a)
        end
      }
    end
  end
end