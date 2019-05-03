# Not used, because virtual field `password` is not available here
class UserBox < Avram::Box
  def initialize
    login ""
    # password ""
    first_name ""
    last_name ""
    full_name ""
    birth_date Time.utc
  end
end
