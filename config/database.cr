class AppDatabase < Avram::Database
end

database_name = "pig_market_#{Lucky::Env.name}"

AppDatabase.configure do |settings|
  if Lucky::Env.production?
    settings.url = ENV.fetch("DATABASE_URL")
  else
    settings.url = ENV["DATABASE_URL"]? || Avram::PostgresURL.build(
      database: database_name,
      hostname: ENV["DB_HOST"]?     || "localhost",
      username: ENV["DB_USERNAME"]? || "postgres",
      password: ENV["DB_PASSWORD"]? || "postgres"
    )
  end
end

Avram.configure do |settings|
  # In development and test, raise an error if you forget to preload associations
  settings.lazy_load_enabled   = Lucky::Env.production?
  settings.database_to_migrate = AppDatabase
end
