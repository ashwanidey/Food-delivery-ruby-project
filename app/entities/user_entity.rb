module UserEntity
  class Details < Grape::Entity
    expose :id
    expose :name
    expose :email
    expose :phone_number

    expose :role
    expose :created_at, format_with: :iso8601

    format_with(:iso8601) { |dt| dt.iso8601 if dt }
  end
end
