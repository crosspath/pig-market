abstract class BaseModel < Avram::Model
  def self.database : Avram::Database.class
    AppDatabase
  end

  macro default_columns
    primary_key id : Int32 # Keep Int32 instead of Int64
    timestamps
    add_default_columns
  end

  # Override this macro to add more columns with defauls
  macro add_default_columns
  end
end
