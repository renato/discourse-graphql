module Types
  class SearchPostType < Types::PostType
    description "SearchPostType"

    field :blurb, String, null: false

    def blurb
      Search::GroupedSearchResults.blurb_for(cooked: object[:raw], term: context[:tag], blurb_length: 150)
    end
  end
end
