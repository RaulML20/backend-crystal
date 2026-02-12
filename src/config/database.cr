require "pg"
require "dotenv"

Dotenv.load "#{__DIR__}/../config/.env"

module Database
    @@db : DB::Database?

    def self.init
        db_url = ENV["DATABASE_URL"]
        @@db = DB.open(db_url)
    end

    def self.db : DB::Database
        @@db || raise "Database not initialized. Call MyDatabase.init first."
    end
end