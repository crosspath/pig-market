# BUG in Avram:
# Empty strings are considered as nulls

module Avram::Validations
  private def validate_required(*fields, message = "is required")
    fields.each do |field|
      if field.value.nil?
        field.add_error message
      end
    end
  end
end

class Avram::Field(T)
  def value
    @value
  end
end
