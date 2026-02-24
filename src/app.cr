require "http/server"
require "dotenv"

Dotenv.load "#{__DIR__}/config/.env"

require "./config/database"
require "./config/security"
require "./config/cors"
require "./utils/exception"
require "./router/router"
require "./routes/user.route"

Database.init

db = Database.db

class HTTP::Server::Context
  property params = Hash(String, String).new
  property user_id : String? = nil
end

router = Router.new
UserRoute.new(router, db)

server = HTTP::Server.new do |context|
  begin
    Security.apply_security_headers(context.response)

    handled = CORS.handle(context)
    next if handled

    router.handle(context)
  rescue ex : GenericException
    context.response.status_code = ex.status
    context.response.content_type = "application/json"
    context.response.print({ ok: 0, error: ex.message }.to_json)
  rescue ex
    context.response.status_code = 500
    context.response.content_type = "application/json"
    context.response.print({ error: "Internal server error: #{ex.message}" }.to_json)
  end
end

address = server.bind_tcp ENV["PORT"]?.try(&.to_i) || 8080
puts "Listening on http://#{address}"
server.listen