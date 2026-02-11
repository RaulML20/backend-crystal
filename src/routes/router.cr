class Router
    def initialize
        @routes = {} of String => Proc(HTTP::Server::Context, Nil)
        @baseURL = "/api/v1"
    end

    def addRoute(method : String, path : String, &block : Proc(HTTP::Server::Context, Nil))
        route_key = "#{method}:#{@baseURL}#{path}"
        @routes[route_key] = block
    end

    private def checkDynamicRoutes(method : String, path : String, context : HTTP::Server::Context) : Bool
        parts = path.split("/").select { |part| part != "" }

        if parts.size > 4
            routeToMatch = "#{method}:/#{parts[0]}/#{parts[1]}/#{parts[2]}/#{parts[3]}"
            partSize = parts.size

            matchingRoute = @routes.find do |route|
                route.first.includes?(routeToMatch) && 
                route.first.split("/").select { |r| r != "" }.size == partSize + 1
            end

            if matchingRoute
                route_key = matchingRoute.first

                paramsKeyList = route_key.gsub(routeToMatch, "").split("/:").select { |r| r != "" }
                pathToFilterParamsValue = "/#{parts[0]}/#{parts[1]}/#{parts[2]}/#{parts[3]}"
                paramsValueList = path.gsub(pathToFilterParamsValue, "").split("/").select { |r| r != "" }

                params = {} of String => String
  
                paramsKeyList.each_with_index do |param, index|
                    params[param] = paramsValueList[index] || ""
                end

                context.params = params

                @routes[route_key].call(context)
                return true
            end
        end

        return false
    end

    private def notFound(context : HTTP::Server::Context)
        context.response.status_code = 404
        context.response.print "404 Not Found"
    end

    def handle(context : HTTP::Server::Context)
        method = context.request.method
        path = context.request.path

        route_key = "#{method}:#{path}"

        if route = @routes[route_key]?
            route.call(context)
        else
            result = checkDynamicRoutes(method, path, context)
            unless result
                notFound(context)
            end
        end
    end
end