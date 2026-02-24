require "./trie.node"
require "../middleware/Auth"

class Router
    BASE_URL = "/api/v1"

    def initialize
        @root = TrieNode.new
    end

    private def notFound(context : HTTP::Server::Context) 
        context.response.status_code = 404 
        context.response.print "404 Not Found" 
    end

    private def method_not_allowed(context : HTTP::Server::Context)
        context.response.status_code = 405
        context.response.print "405 Method Not Allowed"
    end

    def addRoute(method : String, path : String, auth : Bool = false, &block : Proc(HTTP::Server::Context, Nil))
        full_path = "#{BASE_URL}#{path}"
        parts = full_path.split('/', remove_empty: true)

        node = @root

        parts.each do |part|
            if part.starts_with?(":")
                node = (node.dynamic_child ||= TrieNode.new)
                node.param_name = part[1..]
            else
                node = (node.children[part] ||= TrieNode.new)
            end
        end

        node.handlers[method] = block
        node.protected_routes[method] = auth
    end

    def handle(context : HTTP::Server::Context)
        method = context.request.method
        parts = context.request.path.split('/', remove_empty: true)

        node = @root
        params = {} of String => String

        parts.each do |part|
            if child = node.children[part]?
                node = child
            elsif dynamic = node.dynamic_child
                node = dynamic
                if param = node.param_name
                    params[param] = part
                end
            else
                return notFound(context)
            end
        end

        if handler = node.handlers[method]?
            if node.protected_routes[method]? && !Auth.validate(context)
                context.response.status_code = 401
                context.response.print "Access prohibited"
                return
            end

            context.params = params
            handler.call(context)
        else
            if node.handlers.empty?
                notFound(context)
            else
                method_not_allowed(context)
            end
        end
    end
end