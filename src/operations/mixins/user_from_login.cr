module UserFromLogin
  private def user_from_login : User?
    login.value.try do |value|
      UserQuery.new.login(value).first?
    end
  end
end
