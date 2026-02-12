require "../repositories/user.repository"
require "../services/user.service"
require "../controllers/user.controller"

class UserRoute
    def initialize(router : Router, db : DB::Database)
        baseURL = "/users"

        user_repository = UserRepository.new(db)
        user_service = UserService.new(user_repository)
        user_controller = UserController.new(user_service)

        router.addRoute("GET", "#{baseURL}/readAll") do |context|
            user_controller.readAll(context)
        end

        router.addRoute("POST", "#{baseURL}/add") do |context|
            user_controller.add(context)
        end

        router.addRoute("GET", "#{baseURL}/read/:id", auth: true) do |context|
            user_controller.read(context)
        end
    end
end