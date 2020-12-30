# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :categories, [CategoryType], null: false do
      description 'List of categories that user has access to'
    end

    field :search, [SearchPostType], null: true do
      description 'Search for posts'
      argument :term, String, required: true
      argument :page, Int, required: false
    end

    field :latest_topics, [TopicType], null: false do
      description 'Latest topics'
      argument :page, Int, required: false
      argument :category_id, Int, required: false
    end

    field :tag_details, TagDetailsType, null: false do
      description 'Tag details for Compara Jogos'
      argument :tag, String, required: true
    end

    def search(term:, page: 1)
      if term.length < SiteSetting.min_search_term_length
        raise GraphQL::ExecutionError, "Your search term is too short."
      end

      search_args = {
        type_filter: 'topic',
        guardian: context[:guardian],
        blurb_length: 300,
        page: page,
      }

      result = Search.new(term, search_args).execute
      context.scoped_set!(:result, result)
      result.posts
    end

    def latest_topics(page: 0, category_id: nil)
      opts = {
        guardian: context[:guardian],
        page: page,
        category: category_id
      }

      TopicQuery.new(context[:guardian].user, opts).list_latest.topics
    end

    def categories
      CategoryList.new(context[:guardian]).categories
    end

    def tag_details(tag:)
      { tag: tag }
    end
  end
end
