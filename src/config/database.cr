require "pg"

module Database
    @@db : DB::Database?

    def self.init
        @@db = DB.open("postgres://#{ENV["DB_USER"]}:#{ENV["DB_PASSWORD"]}@#{ENV["DB_HOST"]}:#{ENV["DB_PORT"]}/#{ENV["DB_NAME"]}")
    end

    def self.db : DB::Database
        @@db || raise "Database not initialized. Call MyDatabase.init first."
    end
end