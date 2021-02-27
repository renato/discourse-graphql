# frozen_string_literal: true

module Types
  DATA_TAG = "ficha"
  IMAGE_TAG = "imagem"
  class TagDetailsType < Types::BaseObject
    field :topics, [TopicWithPostsType], null: false
    field :feed, [SearchPostType], null: false
    field :data, TopicWithPostsType, null: false
    field :image, TopicWithPostsType, null: false

    def topics
      opts = {
        guardian: context[:guardian],
        page: 0,
        tags: [object[:tag]]
      }
      TopicQuery.new(nil, opts).list_latest.topics
    end

    def feed
      search_args = {
        type_filter: 'topic',
        guardian: context[:guardian],
        blurb_length: 300,
        page: 1
      }
      result = Search.new("\"\\##{object[:tag]}\"", search_args).execute
      context.scoped_set!(:result, result)
      result.posts
    end

    def data
      find_by_tags([DATA_TAG, object[:tag]])
    end

    def image
      find_by_tags([IMAGE_TAG, object[:tag]])
    end

    private
    def find_by_tags(tags)
      res = Topic
      tags.each_with_index do |tag, index|
        join_alias = ['j', index].join
        tag_alias = ['t', index].join
        res = res.joins("INNER JOIN topic_tags #{join_alias} ON #{join_alias}.topic_id = topics.id INNER JOIN tags #{tag_alias} on #{tag_alias}.id = #{join_alias}.tag_id")
        res = res.where("#{tag_alias}.name" => tag)
      end
      res.first
    end
  end
end
