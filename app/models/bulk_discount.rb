class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items

  validates :percent_discount, presence: true, numericality: true
  validates :quantity_threshold, presence: true, numericality: true
  validates :name, presence: true
end