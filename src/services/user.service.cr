require "../entities/user.entity"
require "../dtos/user.dto"
require "../repositories/user.repository";

class UserService
    def initialize(@user_repository : UserRepository); end

    def read(id : Int32)
        @user_repository.read(id)
    end

    def readAll
        @user_repository.readAll
    end 

    def add(user_dto : CreateUserDTO)
        user = User.new(user_dto.name, user_dto.email)
        @user_repository.add(user)
    end
end