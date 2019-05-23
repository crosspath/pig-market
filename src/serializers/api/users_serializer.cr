class Api::UsersSerializer < Lucky::Serializer
  def initialize(@users : Array(User) | UserQuery); end

  def render
    @users.map do |u|
      Api::UserSerializer.new(u)
    end
  end
end
