class UserController
    def initialize()
    end

    def readAll(context : HTTP::Server::Context)
        context.response.content_type = "application/json"
        users = [] of String
        context.response.print users.to_json
    end 

    def create(context : HTTP::Server::Context)
        context.response.content_type = "application/json"
        name = context.params["name"]?
        email = context.params["email"]?
        context.response.print "Created new user"
    end

    def read(context : HTTP::Server::Context)
        context.response.content_type = "application/json"
        id = context.params["id"]?
        user = {} of String => String
        context.response.print user.to_json
    end
end