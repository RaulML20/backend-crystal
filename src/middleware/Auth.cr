require "jwt"
require "dotenv"

Dotenv.load "#{__DIR__}/../config/.env"

module Auth
    SECRET = ENV["SECRET_KEY"]? || ""
    
    def self.validate(context : HTTP::Server::Context) : Bool
        auth_header = context.request.headers["Authorization"]?
        
        if auth_header && auth_header.starts_with?("Bearer ")
            token = auth_header.split(" ").last
        
            begin
                payload, _header = JWT.decode(token, SECRET, JWT::Algorithm::HS256)
                
                context.user_id = payload["sub"].to_s
                return true
            rescue
                return false
            end
        end
        
        false
    end
end