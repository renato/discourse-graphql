module Types
  class PostCustomType < Types::PostType
    field :custom_field, String, null: true do
      argument :name, String, required: true
    end

    def custom_field(name:)
      # N+1?
      object.custom_fields[name]
    end
  end
end
