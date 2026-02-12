require "json"
require "../entities/user.entity"

struct UserDTO
    include JSON::Serializable

    property id : Int32
    property name : String
    property email : String

    def initialize(user : User)
        @id = user.id
        @name = user.name
        @email = user.email
    end

    def self.to_DTOs(users : Array(User)) : Array(UserDTO)
        users.map { |user| UserDTO.new(user) }
    end
end