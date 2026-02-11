class TrieNode
    property children = {} of String => TrieNode
    property dynamic_child : TrieNode? = nil
    property param_name : String? = nil
    property handlers = {} of String => Proc(HTTP::Server::Context, Nil)
    property protected_routes = {} of String => Bool
end