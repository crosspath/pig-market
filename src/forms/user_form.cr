class UserForm < User::BaseForm
  fillable login, first_name, last_name, full_name, birth_date, bonuses, role
  virtual password : String

  def prepare
    if password.value
      crypto = Crypto::Bcrypt::Password.create(password.value.as(String), cost: 10)
      crypted_password.value = crypto.to_s
    end

    if full_name.value.blank?
      full_name.value = "#{last_name.value} #{first_name.value}"
    end
  end

  def set_birth_date_from_param(_value)
    parse_result = Time::Lucky.parse(_value)
    if parse_result.is_a? Avram::Type::SuccessfulCast
      birth_date.value = parse_result.value
    else
      birth_date.value = nil
    end
  end
end
