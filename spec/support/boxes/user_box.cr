class UserBox < Avram::Box
  def initialize
    login "#{sequence("test-user")}"
    crypted_password UserForm.crypt_password("password")
  end
end
