require "../dtos/user.dto"
require "../entities/user.entity"

class UserController
    def initialize(@user_service : UserService); end

    def readAll(context : HTTP::Server::Context)
        context.response.content_type = "application/json"
        
        users = @user_service.readAll

        dto_list = UserDTO.to_DTOs(users) 
        context.response.print dto_list.to_json
    end 

    def add(context : HTTP::Server::Context)
        context.response.content_type = "application/json"

        name = context.params["name"]?
        email = context.params["email"]?
        
        id = @user_service.add(name, email)

        context.response.print "Created new user"
    end

    def read(context : HTTP::Server::Context)
        context.response.content_type = "application/json"

        id = context.params["id"]?
        
        unless id
            raise "ID parameter not provided"
        end
        
        user = @user_service.read(id)

        #context.response.print user.to_json
        context.response.print ""
    end
end