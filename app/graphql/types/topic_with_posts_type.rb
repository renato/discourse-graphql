module Types
  class TopicWithPostsType < Types::TopicType
    field :title, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :last_posted_at, GraphQL::Types::ISO8601DateTime, null: false
    field :reply_count, Int, null: false
    field :like_count, Int, null: false
    field :posts, [PostWithImagesType], null: false
    field :tags, [String], null: false
    field :image_url, String, null: true
    field :user, UserType, null: false
    field :last_poster, UserType, null: false
    field :custom_field, String, null: true do
      argument :name, String, required: true
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
  end
end
