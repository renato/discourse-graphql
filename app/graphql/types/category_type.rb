# frozen_string_literal: true

module Types
  class CategoryType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :topic_count, Int, null: false
    field :post_count, Int, null: false
    field :description, String, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :latest_post, PostType, null: true
    field :latest_topic, TopicType, null: true
    field :parent_category, CategoryType, null: true

    def latest_post
      Loaders::RecordLoader.for(Post).load(object.latest_post_id)
    end

    def latest_topic
      Loaders::RecordLoader.for(Topic).load(object.latest_topic_id)
    end

    def parent_category
      Loaders::RecordLoader.for(Category).load(object.parent_category_id)
    end
  end
end
