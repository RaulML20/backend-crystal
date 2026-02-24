require "jwt"

module Auth
    SECRET = ENV["SECRET_KEY"]? || raise "SECRET_KEY not defined in .env file"
    
    def self.validate(context : HTTP::Server::Context) : Bool
        begin
            token = context.request.cookies["token"]?
        
            return false unless token
            
            payload, _ = JWT.decode(token.value, SECRET, JWT::Algorithm::HS256)
                
            exp_val = payload["exp"]?

            return false unless exp_val

            exp_i =
                case exp_val
                when Int32, Int64 then exp_val.to_i64
                when Float64 then exp_val.to_i64
                when String then exp_val.to_i64? || return false
                else
                    return false
                end

            leeway = 10
            return false if Time.utc.to_unix > (exp_i + leeway)

            sub = payload["sub"]?.try(&.to_s)

            return false unless sub && !sub.empty?
            
            context.user_id = sub
            
            return true
        rescue JWT::DecodeError
            return false
        rescue ex : Exception
            puts "Unexpected error: #{ex.message}"
            return false
        end
    end
end