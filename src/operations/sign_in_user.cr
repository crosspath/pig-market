class SignInUser < Avram::Operation
  param_key :user
  # You can modify this in src/operations/mixins/user_from_login.cr
  include UserFromLogin

  attribute login : String
  attribute password : String

  # Run validations and yields the operation and the user if valid
  def submit
    user = user_from_login
    validate_credentials(user)

    if valid?
      yield self, user
    else
      yield self, nil
    end
  end

  # `validate_credentials` determines if a user can sign in.
  #
  # If desired, you can add additional checks in this method, e.g.
  #
  #    if user.locked?
  #      email.add_error "is locked out"
  #    end
  private def validate_credentials(user)
    if user
      unless Authentic.correct_password?(user, password.value.to_s)
        password.add_error "is wrong"
      end
    else
      # Usually ok to say that a login is not in the system:
      # https://kev.inburke.com/kevin/invalid-username-or-password-useless/
      # https://github.com/luckyframework/lucky_cli/issues/192
      login.add_error "is not in our system"
    end
  end
end