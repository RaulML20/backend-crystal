require "db"
require "../dtos/user.dto"

class User
    include DB::Serializable

    property id : Int32?
    property name : String
    property email : String

    def initialize(@name : String, @email : String, @id : Int32? = nil)
    end
end