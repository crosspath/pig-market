class Api::UserSerializer < BaseSerializer
  def initialize(@user : User); end

  def render
    {
      id:         @user.id,
      login:      @user.login,
      first_name: @user.first_name,
      last_name:  @user.last_name,
      full_name:  @user.full_name,
      birth_date: @user.birth_date,
      bonuses:    @user.bonuses,
      role:       @user.role,
      role_name:  User::UserRole.from_value?(@user.role)
    }
  end
end
