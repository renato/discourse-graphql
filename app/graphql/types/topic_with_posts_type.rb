module Types
  class TopicWithPostsType < Types::TopicType
    field :posts, [PostWithImagesType], null: false

    def posts
      # N+1, but at most 1 topic so not a problem
      object.posts
    end
  end
end
