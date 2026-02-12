require "../repositories/user.repository";

class UserService
    def initialize(@user_repository : UserRepository); end

    def readAll
        @user_repository.readAll
    end 

    def add(name : String | Nil, email : String | Nil)
        
    end

    def read(id : String)
        
    end
end