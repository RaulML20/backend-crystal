class UserRoute
    def initialize(router)
        baseURL = "/users"

        router.addRoute("GET", "#{baseURL}/readAll") do |context|
            context.response.content_type = "text/plain"
            context.response.print "List of users"
        end

        router.addRoute("POST", "#{baseURL}/add") do |context|
            context.response.content_type = "text/plain"
            context.response.print "Create a new user"
        end

        router.addRoute("GET", "#{baseURL}/read/:id", auth: true) do |context|
            context.response.content_type = "text/plain"

            id = context.params["id"]?

            context.response.print "User with ID #{id}"
        end
    end
end