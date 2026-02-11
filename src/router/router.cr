require "./trie.node"
require "../middleware/Auth"

class Router
    def initialize
        @root = TrieNode.new
        @baseURL = "/api/v1"
    end

    private def notFound(context : HTTP::Server::Context) 
        context.response.status_code = 404 
        context.response.print "404 Not Found" 
    end

    def addRoute(method : String, path : String, auth : Bool = false, &block : Proc(HTTP::Server::Context, Nil))
        full_path = "#{@baseURL}#{path}"
        parts = full_path.split("/").reject(&.empty?)

        node = @root

        parts.each do |part|
            if part.starts_with?(":")
                node.dynamic_child ||= TrieNode.new
                node = node.dynamic_child.not_nil!
                node.param_name = part[1..]
            else
                node.children[part] ||= TrieNode.new
                node = node.children[part]
            end
        end

        node.handlers[method] = block
        node.protected_routes[method] = auth
    end

    def handle(context : HTTP::Server::Context)
        method = context.request.method
        parts = context.request.path.split("/").reject(&.empty?)

        node = @root
        params = {} of String => String

        parts.each do |part|
            if child = node.children[part]?
                node = child
            elsif node.dynamic_child
                node = node.dynamic_child.not_nil!
                if param = node.param_name
                    params[param] = part
            end
            else
                return notFound(context)
            end
        end

        if node.handlers.any?
            if handler = node.handlers[method]?
                if node.protected_routes[method] && !Auth.validate(context)
                    context.response.status_code = 401
                    context.response.print "Access prohibited"
                    return
                end

                context.params = params
                handler.call(context)
            else
                context.response.status_code = 405
                context.response.print "405 Method Not Allowed"
            end
        else
            notFound(context)
        end
    end
end