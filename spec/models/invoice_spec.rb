require 'rails_helper'

RSpec.describe Invoice, type: :model do
  let!(:merchant1) { create(:merchant) }
  let!(:merchant2) { create(:merchant) }

  let!(:invoice1) { create(:completed_invoice, created_at: DateTime.now - 12) }
  let!(:invoice2) { create(:completed_invoice, created_at: DateTime.now - 2) }
  let!(:invoice3) { create(:completed_invoice, created_at: DateTime.now - 3) }
  let!(:invoice4) { create(:completed_invoice, created_at: DateTime.now - 4) }
  let!(:invoice5) { create(:completed_invoice, created_at: DateTime.now - 5) }
  let!(:invoice6) { create(:completed_invoice, created_at: DateTime.now - 6) }
  let!(:invoice7) { create(:completed_invoice, created_at: DateTime.now - 7) }
  let!(:invoice8) { create(:completed_invoice, created_at: DateTime.now - 8) }
  let!(:invoice9) { create(:completed_invoice, created_at: DateTime.now - 9) }
  let!(:invoice10) { create(:completed_invoice, created_at: DateTime.now - 10) }
  let!(:invoice11) { create(:completed_invoice, created_at: DateTime.now - 11) }

  let!(:item1) { create(:item, merchant: merchant1) }
  let!(:item2) { create(:item, merchant: merchant1) }
  let!(:item3) { create(:item, merchant: merchant1) }
  let!(:item4) { create(:item, merchant: merchant1) }
  let!(:item5) { create(:item, merchant: merchant1) }
  let!(:item6) { create(:item, merchant: merchant2) }

  let!(:invoice_item1) { create(:invoice_item, invoice: invoice1, item: item1, status: 0, quantity: 3) }
  let!(:invoice_item2) { create(:invoice_item, invoice: invoice2, item: item2, status: 1) }
  let!(:invoice_item3) { create(:invoice_item, invoice: invoice2, item: item3, status: 2) }
  let!(:invoice_item4) { create(:invoice_item, invoice: invoice3, item: item3, status: 2) }
  let!(:invoice_item5) { create(:invoice_item, invoice: invoice4, item: item4, status: 1) }
  let!(:invoice_item6) { create(:invoice_item, invoice: invoice5, item: item5, status: 0) }
  let!(:invoice_item7) { create(:invoice_item, invoice: invoice5, item: item4, status: 0) }
  let!(:invoice_item8) { create(:invoice_item, invoice: invoice6, item: item4, status: 2) }
  let!(:invoice_item9) { create(:invoice_item, invoice: invoice7, item: item3, status: 1) }
  let!(:invoice_item10) { create(:invoice_item, invoice: invoice8, item: item2, status: 0) }
  let!(:invoice_item11) { create(:invoice_item, invoice: invoice9, item: item1, status: 2) }
  let!(:invoice_item12) { create(:invoice_item, invoice: invoice10, item: item2, status: 1) }
  let!(:invoice_item13) { create(:invoice_item, invoice: invoice10, item: item5, status: 0) }
  let!(:invoice_item14) { create(:invoice_item, invoice: invoice11, item: item3, status: 0) }

  describe 'relationships' do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items)}
    it { should have_many(:merchants).through(:items) }
    it { should have_many(:bulk_discounts).through(:merchants)}
    it { should define_enum_for(:status).with_values(["cancelled", "in progress", "completed"])}
  end

  describe 'class methods' do
    describe '::invoice_items_not_shipped' do
      it 'lists the ids of all invoices that have items that have not shipped' do
        expect(Invoice.invoice_items_not_shipped).to eq([invoice1, invoice11, invoice10, invoice8, invoice7, invoice5, invoice4, invoice2])

        create(:invoice_item, invoice: invoice3, item: item1)

        expect(Invoice.invoice_items_not_shipped).to eq([invoice1, invoice11, invoice10, invoice8, invoice7, invoice5, invoice4, invoice3, invoice2])
      end
    end
  end

  describe 'instance_methods' do
    describe 'items_for_merchant()' do
      it 'returns a list of items that belong to a merchant for a specific invoice' do
        create(:invoice_item, invoice: invoice2, item: item6)

        expect(invoice2.items_for_merchant(merchant1)).to eq([item2, item3])
        expect(invoice2.items_for_merchant(merchant2)).to eq([item6])
      end
    end

    describe '#merchant_total_revenue()' do
      it 'returns the total revenue generated for a merchant from an invoice' do
        invoice_item15 = create(:invoice_item, invoice: invoice1, item: item2)
        invoice_item16 = create(:invoice_item, invoice: invoice1, item: item6)

        merchant1_revenue = (invoice_item1.unit_price * invoice_item1.quantity) + (invoice_item15.unit_price * invoice_item15.quantity)

        expect(invoice1.merchant_total_revenue(merchant1).round(2)).to eq(merchant1_revenue.round(2))

        merchant2_revenue = (invoice_item16.unit_price * invoice_item16.quantity)

        expect(invoice1.merchant_total_revenue(merchant2).round(2)).to eq(merchant2_revenue.round(2))
      end
    end

    describe '#merchant_total_discounts()' do
      it 'returns the total discounts applied to invoice items for a specific merchant' do
        merchant1.bulk_discounts.create!(percent_discount: 20, quantity_threshold: 5)
        invoice_item15 = create(:invoice_item, invoice: invoice1, item: item2, status: 0, quantity: 5)
        invoice_item16 = create(:invoice_item, invoice: invoice1, item: item3, status: 0, quantity: 8)
        invoice_item17 = create(:invoice_item, invoice: invoice1, item: item6, status: 0, quantity: 8)
        invoice_item18 = create(:invoice_item, invoice: invoice2, item: item6, status: 0, quantity: 8)

        # single bulk_discount for merchant1
        total_discount = (invoice_item15.unit_price * 0.20 * 5) + (invoice_item16.unit_price * 0.20 * 8)

        expect(invoice1.merchant_total_discounts(merchant1).round(2)).to eq(total_discount.round(2))

        # two bulk_discounts for merchant1
        merchant1.bulk_discounts.create!(percent_discount: 30, quantity_threshold: 7)

        total_discount2 = (invoice_item15.unit_price * 0.20 * 5) + (invoice_item16.unit_price * 0.30 * 8)

        expect(invoice1.merchant_total_discounts(merchant1).round(2)).to eq(total_discount2.round(2))

        # three bulk_discounts for merchant1, but one has a lower percent_discount and larger quantity_threshold (never applied)
        merchant1.bulk_discounts.create!(percent_discount:15, quantity_threshold: 8)

        expect(invoice1.merchant_total_discounts(merchant1).round(2)).to eq(total_discount2.round(2))

        # single bulk_discount for merchant 2 (never applied to total_discounts(merchant1))
        merchant2.bulk_discounts.create!(percent_discount:10, quantity_threshold: 3)

        expect(invoice1.merchant_total_discounts(merchant1).round(2)).to eq(total_discount2.round(2))
      end
    end

    describe '#merchant_discounted_revenue()' do
      it "returns the discounted revenue for a merchant's invoice items" do
        merchant1.bulk_discounts.create!(percent_discount: 20, quantity_threshold: 5)
        invoice_item15 = create(:invoice_item, invoice: invoice1, item: item2, status: 0, quantity: 5)
        invoice_item16 = create(:invoice_item, invoice: invoice1, item: item3, status: 0, quantity: 8)

        total_revenue = (invoice_item1.unit_price * invoice_item1.quantity) + (invoice_item15.unit_price * invoice_item15.quantity) + (invoice_item16.unit_price * invoice_item16.quantity)
        total_discount = (invoice_item15.unit_price * 0.20 * 5) + (invoice_item16.unit_price * 0.20 * 8)
        discounted_revenue = total_revenue - total_discount

        expect(invoice1.merchant_discounted_revenue(merchant1).round(2)).to eq(discounted_revenue.round(2))

        merchant2.bulk_discounts.create!(percent_discount:10, quantity_threshold: 3)
        invoice_item17 = create(:invoice_item, invoice: invoice1, item: item6, status: 0, quantity: 8)

        discounted_revenue_2 = (invoice_item17.unit_price * invoice_item17.quantity) - (invoice_item17.unit_price * 0.10 * 8)

        expect(invoice1.merchant_discounted_revenue(merchant2).round(2)).to eq(discounted_revenue_2.round(2))
      end
    end

    describe '#total_revenue' do
      it 'returns the total revenue generated for an invoice' do
        revenue = (invoice_item1.unit_price * invoice_item1.quantity)
        
        expect(invoice1.total_revenue.round(2)).to eq(revenue.round(2))
       
        revenue_2 = (invoice_item2.unit_price * invoice_item2.quantity) + (invoice_item3.unit_price * invoice_item3.quantity)

        expect(invoice2.total_revenue.round(2)).to eq(revenue_2.round(2))        
      end
    end

    describe '#total_discounts' do
      it 'returns the total discount for an invoice' do
        merchant1.bulk_discounts.create!(percent_discount: 20, quantity_threshold: 5)
        merchant2.bulk_discounts.create!(percent_discount:10, quantity_threshold: 3)

        invoice_item15 = create(:invoice_item, invoice: invoice1, item: item2, status: 0, quantity: 5)
        invoice_item16 = create(:invoice_item, invoice: invoice1, item: item3, status: 0, quantity: 8)
        invoice_item17 = create(:invoice_item, invoice: invoice1, item: item6, status: 0, quantity: 8)

        total_discount = (invoice_item15.unit_price * 0.20 * 5) + (invoice_item16.unit_price * 0.20 * 8) + (invoice_item17.unit_price * 0.10 * 8)

        expect(invoice1.total_discounts.round(2)).to eq(total_discount.round(2))

        merchant2.bulk_discounts.create!(percent_discount:20, quantity_threshold: 7)

        total_discount_2 = (invoice_item15.unit_price * 0.20 * 5) + (invoice_item16.unit_price * 0.20 * 8) + (invoice_item17.unit_price * 0.20 * 8)

        expect(invoice1.total_discounts.round(2)).to eq(total_discount_2.round(2))
      end
    end

    describe '#discounted_revenue' do
      it 'returns the total discounted revenue for an invoice' do
        merchant1.bulk_discounts.create!(percent_discount: 20, quantity_threshold: 5)
        merchant2.bulk_discounts.create!(percent_discount:10, quantity_threshold: 3)

        invoice_item15 = create(:invoice_item, invoice: invoice1, item: item2, status: 0, quantity: 5)
        invoice_item16 = create(:invoice_item, invoice: invoice1, item: item3, status: 0, quantity: 8)
        invoice_item17 = create(:invoice_item, invoice: invoice1, item: item6, status: 0, quantity: 8)

        total_revenue = (invoice_item1.unit_price * invoice_item1.quantity) + (invoice_item15.unit_price * invoice_item15.quantity) + (invoice_item16.unit_price * invoice_item16.quantity) + (invoice_item17.unit_price * invoice_item17.quantity)
        total_discount = (invoice_item15.unit_price * 0.20 * 5) + (invoice_item16.unit_price * 0.20 * 8) + (invoice_item17.unit_price * 0.10 * 8)
        discounted_revenue = total_revenue - total_discount
        
        expect(invoice1.discounted_revenue.round(2)).to eq(discounted_revenue.round(2))

        merchant2.bulk_discounts.create!(percent_discount:20, quantity_threshold: 7)

        total_discount_2 = (invoice_item15.unit_price * 0.20 * 5) + (invoice_item16.unit_price * 0.20 * 8) + (invoice_item17.unit_price * 0.20 * 8)
        discounted_revenue = total_revenue - total_discount_2

        expect(invoice1.discounted_revenue.round(2)).to eq(discounted_revenue.round(2))
      end
    end
  end
end
