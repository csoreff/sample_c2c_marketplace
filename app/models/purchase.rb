class Purchase < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :amount, :user_id, :product_id, presence: true

  validates :amount, numericality: { only_integer: true }
end
