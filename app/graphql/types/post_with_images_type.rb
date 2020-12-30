module Types
  class PostWithImagesType < Types::PostType
    field :images, [String], null: false

    def images
      # We could query post.uploads, but let's start naive
      Nokogiri::HTML(object[:cooked]).css('img').map do |img|
        img[:src]
      end
    end
  end
end
