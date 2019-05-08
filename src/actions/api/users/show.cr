class Api::Users::Show < ApiAction
  route do
    user = UserQuery.new.preload_bonus_account.preload_addresses.find(user_id)

    address_ids = user.addresses.map(&.id).to_a
    orders = OrderQuery.new.address_id.in(address_ids)

    result = Api::UserSerializer.new(user, orders)

    response_success(user: result)
  rescue e
    response_error(500, e)
  end
end
