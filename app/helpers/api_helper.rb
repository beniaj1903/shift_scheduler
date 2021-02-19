module ApiHelper
    def self.api_response_normalization array
        new_array = []
        array.each do |object|
            new_array << { [object.id] => object.attributes.except("created_at", "updated_at") }
        end
        new_array
    end
end
