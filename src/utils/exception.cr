class GenericException < Exception
    getter status : Int32

    def initialize(message : String, @status : Int32 = 400)
        super(message)
    end
end