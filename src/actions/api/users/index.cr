class Api::Users::Index < ApiAction
  route do
    users = UserQuery.new.login.asc_order

    result = Api::UserSerializer.for_collection(users)

    response_success(users: result)
  rescue e
    response_error(500, e)
  end
end
