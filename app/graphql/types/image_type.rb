# frozen_string_literal: true

module Types
  class ImageType < Types::BaseObject
    field :id, ID, null: false
    field :user, UserType, null: false
    field :image_url, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
