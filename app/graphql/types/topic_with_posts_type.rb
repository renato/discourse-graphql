module Types
  class TopicWithPostsType < Types::TopicType
    field :title, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :last_posted_at, GraphQL::Types::ISO8601DateTime, null: false
    field :bumped_at, GraphQL::Types::ISO8601DateTime, null: false
    field :pinned_globally, Boolean, null: false
    field :highest_post_number, Int, null: false
    field :like_count, Int, null: false
    field :posts, [PostCustomType], null: false
    field :tags, [String], null: false
    field :image_url, String, null: true
    field :user, UserType, null: false
    field :last_poster, UserType, null: false
    field :custom_field, String, null: true do
      argument :name, String, required: true
    end
    field :images, [ImageType], null: false do
      argument :op, Boolean, required: false
    end

    def posts
      # N+1?
      object.posts
    end

    def tags
      # N+1?
      object.tags.map { |tag| tag.name }
    end

    def user
      Loaders::RecordLoader.for(User).load(object.user_id)
    end

    def last_poster
      Loaders::RecordLoader.for(User).load(object.last_post_user_id)
    end

    def custom_field(name:)
      # N+1?
      object.custom_fields[name]
    end

    def images(op: false)
      arr = []
      posts = if op then [object.posts[0]] else object.posts[1..-1] end
      posts.map do |post|
        # We could query post.uploads, but let's start naive
        Nokogiri::HTML(post.cooked).css('img').map.with_index do |img, index|
          arr << { id: "#{post.id}-#{index}", user: post.user, image_url: img[:src], created_at: post.created_at }
        end
      end
      arr
    end
  end
end
