require "../controllers/user.controller"

class UserRoute
    def initialize(router : Router, db_pool : DB::Database)
        baseURL = "/users"

        #user_repository = UserRepository.new(Database)
        #user_service = UserController.new(user_repository)
        user_controller = UserController.new()

        router.addRoute("GET", "#{baseURL}/readAll") do |context|
            user_controller.readAll(context)
        end

        router.addRoute("POST", "#{baseURL}/add") do |context|
            user_controller.create(context)
        end

        router.addRoute("GET", "#{baseURL}/read/:id", auth: true) do |context|
            user_controller.read(context)
        end
    end
end