# Load .env file before any other config or app code
require "dotenv"
Dotenv.load unless ENV.fetch("LUCKY_ENV", "") == "production"

# Require your shards here
require "avram"
require "lucky"
require "carbon"
require "authentic"
