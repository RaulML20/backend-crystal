require "jwt"
require "dotenv"

Dotenv.load "#{__DIR__}/../config/.env"

module Auth
    SECRET = ENV["SECRET_KEY"]? || raise "SECRET_KEY not defined in .env file"
    
    def self.validate(context : HTTP::Server::Context) : Bool
        begin
            token = context.request.cookies["token"]?
        
            unless token
                return false
            end
            
            payload, _header = JWT.decode(token.value, SECRET, JWT::Algorithm::HS256)
                
            context.user_id = payload["sub"].to_s
            return true
        rescue JWT::DecodeError
            return false
        rescue e : Exception
            puts "Unexpected error: #{e.message}"
            return false
        end
    end
end