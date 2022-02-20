class UserFactory < Avram::Factory
  def initialize
    login "#{sequence("test-user")}"
    crypted_password UserForm.crypt_password("password")
  end
end
