class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item
  has_many :bulk_discounts, through: :merchant

  enum status: ["packaged", "pending", "shipped"]

  def list_bulk_discount
    bulk_discounts
    .joins(:invoice_items)
    .where('invoice_items.id =?', self)
    .where('invoice_items.quantity >= bulk_discounts.quantity_threshold')
    .group(:id)
    .order(percent_discount: :desc)
    .limit(1)
    .first
  end
end
