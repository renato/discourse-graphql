module Types
  class PostWithImagesType < Types::PostType
    field :images, [String], null: false
    field :custom_field, String, null: true do
      argument :name, String, required: true
    end

    def images
      # We could query post.uploads, but let's start naive
      Nokogiri::HTML(object[:cooked]).css('img').map do |img|
        img[:src]
      end
    end

    def custom_field(name:)
      # N+1?
      object.custom_fields[name]
    end
  end
end
