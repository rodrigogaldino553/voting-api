class ElectionSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :name, :expiration_at

  has_many :candidates
end
