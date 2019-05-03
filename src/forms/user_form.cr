class UserForm < User::BaseForm
  fillable login, first_name, last_name, full_name, birth_date
  virtual password : String

  def prepare
    if password.value
      crypto = Crypto::Bcrypt::Password.create(password.value.as(String), cost: 10)
      crypted_password.value = crypto.to_s
    end
  end
end
