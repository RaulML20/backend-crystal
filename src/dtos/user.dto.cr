require "json"
require "../entities/user.entity"

struct UserDTO
    include JSON::Serializable

    property id : Int32?
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

struct CreateUserDTO
    include JSON::Serializable

    property name : String
    property email : String

    def validate!
        raise GenericException.new("Name cannot be empty", 400) if name.strip.empty?
        raise GenericException.new("Email cannot be empty", 400) if email.strip.empty?
        raise GenericException.new("Invalid email format", 400) unless valid_email?
    end

    private def valid_email?
        !!(email =~ /^[^@\s]+@[^@\s]+\.[^@\s]+$/)
    end
end