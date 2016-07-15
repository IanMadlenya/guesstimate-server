require 'roar/decorator'

class SpaceRepresenter < Roar::Decorator
  include Roar::JSON
  include Roar::JSON::HAL

  property :id
  property :name
  property :description
  property :created_at
  property :updated_at
  property :graph
  property :is_private
  property :user_id
  property :organization_id
  property :screenshot
  property :big_screenshot

  property :user, class: User, embedded: true  do
    property :id
    property :username, as: "name"
    property :picture
  end

  property :organization, embedded: true, class: Organization do
    property :id
    property :admin_id
    property :name
    property :picture
  end

  collection :calculators, embedded: true, class: Calculator do
    property :id
    property :space_id
    property :title
    property :share_image
    property :content
    property :input_ids
    property :output_ids
  end
end
