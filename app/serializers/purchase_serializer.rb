class PurchaseSerializer < ActiveModel::Serializer
  attributes :id, :amount
  has_one :user
  has_one :product
end
