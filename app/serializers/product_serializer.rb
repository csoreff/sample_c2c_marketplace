class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :cost, :status
  has_one :user
end
