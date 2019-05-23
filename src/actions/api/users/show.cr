class Api::Users::Show < ApiAction
  route do
    user = UserQuery.find(user_id)

    result = Api::UserSerializer.new(user)

    response_success(user: result)
  rescue e
    response_error(500, e)
  end
end
