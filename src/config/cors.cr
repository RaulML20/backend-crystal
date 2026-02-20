require "http/server"

module CORS
    ALLOWED_ORIGINS = { "http://localhost:8080" }
    ALLOWED_METHODS = "GET, POST, PUT, PATCH, DELETE, OPTIONS"
    ALLOWED_HEADERS = "Content-Type, Authorization, X-CSRF-Token"

    def self.handle(context : HTTP::Server::Context) : Bool
        req = context.request
        res = context.response

        origin = req.headers["Origin"]?
        if origin && ALLOWED_ORIGINS.includes?(origin)
            res.headers["Access-Control-Allow-Origin"] = origin
            res.headers["Vary"] = "Origin"
            res.headers["Access-Control-Allow-Methods"] = ALLOWED_METHODS
            res.headers["Access-Control-Allow-Headers"] = ALLOWED_HEADERS
            res.headers["Access-Control-Max-Age"] = "86400"
            # res.headers["Access-Control-Allow-Credentials"] = "true"
        end

        if req.method == "OPTIONS"
            res.status_code = 204
            return true
        end

        false
    end
end