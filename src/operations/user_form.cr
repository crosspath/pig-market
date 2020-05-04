class UserForm < User::SaveOperation
  permit_columns login, first_name, last_name, full_name, birth_date, bonuses, role
  attribute password : String

  before_save do
    if password.value
      string = password.value.as(String)
      crypted_password.value = UserForm.crypt_password(string)
    end

    if full_name.value.blank?
      full_name.value = "#{last_name.value} #{first_name.value}"
    end
  end

  def self.crypt_password(password : String)
    Crypto::Bcrypt::Password.create(password, cost: 10).to_s
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
