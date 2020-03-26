class UserBox < Avram::Box
  def initialize
    login "#{sequence("test-user")}"
    crypted_password Authentic.generate_encrypted_password("password")
  end
end
