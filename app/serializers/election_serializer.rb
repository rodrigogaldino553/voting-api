class ElectionSerializer
  include JSONAPI::Serializer
  attributes :name, :expiration_at

  has_many :candidates
end
