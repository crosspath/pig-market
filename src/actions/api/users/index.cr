class Api::Users::Index < ApiAction
  route do
    users = UserQuery.new.login.asc_order
    users = users.preload_bonus_account
    users = users.preload_addresses

    result = Api::UsersSerializer.new(users)

    response_success(users: result)
  rescue e
    response_error(500, e)
  end
end
