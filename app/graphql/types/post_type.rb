module Types
  class PostType < Types::BaseObject
    description "Post"

    field :id, ID, null: false
    field :name, String, null: true
    field :username, String, null: true
    field :avatar_template, String, null: false
    field :like_count, Int, null: false
    field :post_number, Int, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :cooked, String, null: false
    field :topic, TopicType, null: false

    def name
      if SiteSetting.enable_names?
        object.user&.name
      end
    end

    def username
      object.user&.username
    end

    def avatar_template
      object.user&.avatar_template
    end

    def topic
      Loaders::RecordLoader.for(Topic).load(object.topic_id)
    end
  end
end
