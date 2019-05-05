class AddressBox < Avram::Box
  def initialize
    recipient_type "User"
    recipient_id 0
    city ""
    street ""
    building ""
    additional ""
    hidden false
  end
end
