require "db"

class User
    include DB::Serializable

    property id : Int32
    property name : String
    property email : String

    def initialize(@id, @name, @email)
    end
end