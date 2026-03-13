class ElectionSerializer < ActiveModel::Serializer
  attributes :id, :name, :expiration_at

  has_many :candidates
end
