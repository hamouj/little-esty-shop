require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to :invoice }
    it { should belong_to :item }
    it { should have_one(:merchant).through(:item) }
    it { should have_many(:bulk_discounts).through(:merchant) }
    it { should define_enum_for(:status).with_values(["packaged", "pending", "shipped"])}
  end

  describe 'instance methods' do
    let!(:merchant1) { create(:merchant) }
      
    let!(:invoice1) { create(:completed_invoice) }
    let!(:invoice2) { create(:completed_invoice) }
  
    let!(:item1) { create(:item, merchant: merchant1) }
    let!(:item2) { create(:item, merchant: merchant1) }
    let!(:item3) { create(:item, merchant: merchant1) }
    let!(:item4) { create(:item, merchant: merchant1) }
    let!(:item5) { create(:item, merchant: merchant1) }
  
    let!(:invoice_item1) { create(:invoice_item, invoice: invoice1, item: item1, status: 0, quantity: 3) }
    let!(:invoice_item2) { create(:invoice_item, invoice: invoice1, item: item4, status: 0, quantity: 5) }
    let!(:invoice_item3) { create(:invoice_item, invoice: invoice2, item: item2, status: 1, quantity: 7) }
    let!(:invoice_item4) { create(:invoice_item, invoice: invoice2, item: item3, status: 2, quantity: 5) }

    let!(:bulk_discount1) { BulkDiscount.create!(percent_discount: 10, quantity_threshold: 5, merchant: merchant1) }

    describe '#list_bulk_discount' do
      it 'returns the bulk discount used for the invoice_item, if any' do
        expect(invoice_item1.list_bulk_discount).to eq(nil)

        expect(invoice_item2.list_bulk_discount).to eq(bulk_discount1)

        bulk_discount2 = BulkDiscount.create!(percent_discount: 20, quantity_threshold: 5, merchant: merchant1)

        expect(invoice_item2.list_bulk_discount).to eq(bulk_discount2)
      end
    end
  end
end
