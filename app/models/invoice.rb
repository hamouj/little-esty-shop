class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants
  
  enum status: ["cancelled", "in progress", "completed"]

  def self.invoice_items_not_shipped
    joins(:invoice_items).where.not(invoice_items: {status: 2}).distinct.order(:created_at)
  end

  def total_revenue
    self.invoice_items.sum('invoice_items.unit_price * invoice_items.quantity')
  end

  def merchant_total_revenue(merchant)
    self.items.joins(:invoice_items).where("items.merchant_id = ?", merchant.id).distinct.sum('invoice_items.unit_price * invoice_items.quantity')
  end

  def total_discounts(merchant)
    inner_query = items.joins(:invoice_items, :bulk_discounts).where(items: {merchant_id: merchant.id}).where("invoice_items.quantity >= bulk_discounts.quantity_threshold").group(:id).select("items.id, max(invoice_items.unit_price*(bulk_discounts.percent_discount / 100.0)*invoice_items.quantity) as max_discount")
    self.items.select('max_discount').from(inner_query, :items).sum('max_discount')
  end

  def discounted_revenue(merchant)
    merchant_total_revenue(merchant) - total_discounts(merchant)
  end
end