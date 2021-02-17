class Api::V1::ShiftController < Api::V1::ApiController
    def index
        render json: {
            object: "hello_world"
        }
    end
end
