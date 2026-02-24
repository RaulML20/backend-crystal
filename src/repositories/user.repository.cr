require "../config/transactions"
require "../entities/user.entity"

class UserRepository
    include Transactions

    def initialize(@db : DB::Database); end

    def read(id : Int32)
        @db.query_one?("SELECT * FROM users WHERE id = $1", id, as: User)
    end

    def readAll
        @db.query_all("SELECT * FROM users", as: User)
    end 

    def add(user : User) : User
        #id = nil

        #with_transaction do |tx|
            #id = tx.connection.query_one("INSERT INTO users (name, email) VALUES ($1, $2) RETURNING id", user.name, user.email, as: Int32)
        #end

        id = @db.query_one("INSERT INTO users (name, email) VALUES ($1, $2) RETURNING id", user.name, user.email, as: Int32)
        User.new(user.name, user.email, id)
    end
end