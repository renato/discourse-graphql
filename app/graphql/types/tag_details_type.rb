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
        #guardian: context[:guardian],
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
      "%5C%23dragon-castle"
      result = Search.new("\"\\##{object[:tag]}\"", search_args).execute
      context.scoped_set!(:result, result)
      result.posts
    end

    def data
      opts = {
        guardian: context[:guardian],
        page: 0,
        tags: [DATA_TAG, object[:tag]],
        match_all_tags: true
      }
      TopicQuery.new(context[:guardian].user, opts).list_latest.topics.first
    end

    def image
      opts = {
        guardian: context[:guardian],
        page: 0,
        tags: [IMAGE_TAG, object[:tag]],
        match_all_tags: true
      }
      TopicQuery.new(context[:guardian].user, opts).list_latest.topics.first
    end
  end
end
