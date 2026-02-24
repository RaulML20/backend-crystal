require "../dtos/user.dto"
require "../entities/user.entity"

class UserController
    def initialize(@user_service : UserService); end

    def read(context : HTTP::Server::Context)
        context.response.content_type = "application/json"

        id = context.params["id"]? || raise GenericException.new("ID parameter not provided", 400)

        id_number = id.to_i? || raise GenericException.new("ID parameter not number", 400)

        user = @user_service.read(id_number) || raise GenericException.new("User not found", 404)
        
        user_dto = UserDTO.new(user)
        context.response.print({ ok: 1, data: user_dto }.to_json)
    end

    def readAll(context : HTTP::Server::Context)
        context.response.content_type = "application/json"
        
        users = @user_service.readAll

        dto_list = UserDTO.to_DTOs(users) 
        context.response.print({ ok: 1, data: dto_list }.to_json)
    end 

    def add(context : HTTP::Server::Context)
        context.response.content_type = "application/json"

        body = context.request.body.try(&.gets_to_end) || raise GenericException.new("Body not provided", 400)

        dto = CreateUserDTO.from_json(body)

        dto.validate!

        user = @user_service.add(dto)

        context.response.status_code = 201
        context.response.print({ ok: 1, data: UserDTO.new(user) }.to_json)
    end

end