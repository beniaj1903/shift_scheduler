class Api::V1::ShiftsController < Api::V1::ApiController
    def index
        render json: {
            object: "hello_world"
        }
    end
end
