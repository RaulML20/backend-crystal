require "../entities/user.entity"

class UserRepository
    def initialize(@db : DB::Database); end

    def readAll
        @db.query_all("SELECT * FROM users", as: User)
    end 

    def add(name : String | Nil, email : String | Nil)
        
    end

    def read(id : String | Nil)
        
    end
end