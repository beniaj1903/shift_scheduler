module ApiHelper
    def self.api_response_normalization array
        new_hash = {}
        array.each do |object|
            new_hash[object.id] = object.attributes.except("created_at", "updated_at")
        end
        new_hash
    end
end
