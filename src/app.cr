require "http/server"

require "./router/router"
require "./routes/user.route"

class HTTP::Server::Context
  property params = Hash(String, String).new
  property user_id : String? = nil
end

router = Router.new
UserRoute.new(router)

server = HTTP::Server.new do |context|
  router.handle(context)
end

address = server.bind_tcp 8080
puts "Listening on http://#{address}"
server.listen