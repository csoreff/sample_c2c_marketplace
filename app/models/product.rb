class Product < ApplicationRecord
  belongs_to :user
  has_one :purchase

  validates :name, :description, :cost, :user_id, presence: true
  validates :name, length: { in: 2..50 }

  validates :description, length: { minimum: 5 }

  validates :cost, numericality: { only_integer: true }

  enum status: [ :active, :sold, :canceled ]
end
