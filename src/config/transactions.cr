module Transactions
    def with_transaction(&block : DB::Transaction -> _)
        @db.transaction do |tx|
            yield tx
        end
    rescue ex : PQ::PQError
        handle_pg_error(ex)
    end

    private def handle_pg_error(ex : PQ::PQError)
        state = ex.field_message("C") || "UNKNOWN"

        case state
        when "23505"
            raise GenericException.new("Duplicated record", 409)
        when "23502"
            raise GenericException.new("Missing required field", 400)
        else
            raise GenericException.new("Database error", 500)
        end
    end
end