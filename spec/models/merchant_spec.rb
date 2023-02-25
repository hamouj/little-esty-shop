require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'validations' do
		it { should validate_presence_of(:name) }
	end

  describe 'relationships' do
    it { should have_many :items }
		it { should define_enum_for(:status).with_values(["active", "disabled"])}
  end

	let!(:merchant1) { Merchant.create!(name: "Brian's Beads") }
	let!(:merchant_2) { Merchant.create!(name: 'John Doe') }
	let!(:merchant_3) { Merchant.create!(name: 'Keys Keys') }
	let!(:merchant_4) { Merchant.create!(name: 'Soras Chains', status: 'disabled') }

	let!(:customer1) { Customer.create!(first_name: "Britney", last_name: "Spears") }
	let!(:customer2) { Customer.create!(first_name: "Bob", last_name: "Smith") }
	let!(:customer3) { Customer.create!(first_name: "Bill", last_name: "Johnson") }
	let!(:customer4) { Customer.create!(first_name: "Boris", last_name: "Nelson") }
	let!(:customer5) { Customer.create!(first_name: "Barbara", last_name: "Hilton") }
	let!(:customer6) { Customer.create!(first_name: "Bella", last_name: "Thomas") }

	let!(:invoice1) { customer1.invoices.create!(status: 2) }
	let!(:invoice2) { customer1.invoices.create!(status: 2) }
	let!(:invoice3) { customer2.invoices.create!(status: 2) }
	let!(:invoice4) { customer2.invoices.create!(status: 2) }
	let!(:invoice5) { customer3.invoices.create!(status: 2) }
	let!(:invoice6) { customer3.invoices.create!(status: 2) }
	let!(:invoice7) { customer4.invoices.create!(status: 2) }
	let!(:invoice8) { customer5.invoices.create!(status: 2) }
	let!(:invoice9) { customer5.invoices.create!(status: 2) }
	let!(:invoice10) { customer6.invoices.create!(status: 2) }
	let!(:invoice11) { customer6.invoices.create!(status: 2) }

	let!(:item1) { merchant1.items.create!(name: "water bottle", description: "24oz metal container for water", unit_price: 8) }    
	let!(:item2) { merchant1.items.create!(name: "rubber duck", description: "toy for bath", unit_price: 1) }    
	let!(:item3) { merchant1.items.create!(name: "lamp", description: "12 inch desk lamp", unit_price: 16) }    
	let!(:item4) { merchant1.items.create!(name: "wireless mouse", description: "wireless computer mouse for mac", unit_price: 40) }    
	let!(:item5) { merchant1.items.create!(name: "chapstick", description: "coconut flavor chapstick", unit_price: 2) }    
	let!(:item6) {create(:item, merchant: merchant1)}

	let!(:transaction1) { invoice1.transactions.create!(credit_card_number: 4654405418249632, credit_card_expiration_date: Date.new(2024, 1, 3), result: "success") }
	let!(:transaction2) { invoice2.transactions.create!(credit_card_number: 4654405418249632, credit_card_expiration_date: Date.new(2024, 1, 3), result: "success") }
	
	let!(:transaction3) { invoice3.transactions.create!(credit_card_number: 4140149827486249, credit_card_expiration_date: Date.new(2024, 1, 3), result: "success") }
	let!(:transaction4) { invoice4.transactions.create!(credit_card_number: 4140149827486249, credit_card_expiration_date: Date.new(2024, 1, 3), result: "success") }
 
	let!(:transaction5) { invoice5.transactions.create!(credit_card_number: 4763141973880496, credit_card_expiration_date: Date.new(2024, 1, 3), result: "success") }
	let!(:transaction6) { invoice6.transactions.create!(credit_card_number: 4763141973880496, credit_card_expiration_date: Date.new(2024, 1, 3), result: "success") }
 
	let!(:transaction14) { invoice7.transactions.create!(credit_card_number: 4504301557459341, credit_card_expiration_date: Date.new(2024, 1, 3), result: "failed") }
	let!(:transaction15) { invoice7.transactions.create!(credit_card_number: 4504301557459341, credit_card_expiration_date: Date.new(2024, 1, 3), result: "success") }
	
	let!(:transaction7) { invoice8.transactions.create!(credit_card_number: 4173081602435789, credit_card_expiration_date: Date.new(2024, 1, 3), result: "success") }
	let!(:transaction8) { invoice9.transactions.create!(credit_card_number: 4173081602435789, credit_card_expiration_date: Date.new(2024, 1, 3), result: "success") }
	
	let!(:transaction9) { invoice10.transactions.create!(credit_card_number: 4972246905754900, credit_card_expiration_date: Date.new(2024, 1, 3), result: "failed") }
	let!(:transaction10) { invoice10.transactions.create!(credit_card_number: 4972246905754900, credit_card_expiration_date: Date.new(2024, 1, 3), result: "success") }
	let!(:transaction11) { invoice11.transactions.create!(credit_card_number: 4972246905754900, credit_card_expiration_date: Date.new(2024, 1, 3), result: "success") }
	
	
	before do
		InvoiceItem.create!(item: item1, invoice: invoice1)
		InvoiceItem.create!(item: item2, invoice: invoice1)
		InvoiceItem.create!(item: item1, invoice: invoice2)
		InvoiceItem.create!(item: item4, invoice: invoice2)
		InvoiceItem.create!(item: item4, invoice: invoice3)
		InvoiceItem.create!(item: item3, invoice: invoice3)
		InvoiceItem.create!(item: item1, invoice: invoice4)
		InvoiceItem.create!(item: item4, invoice: invoice4)
		InvoiceItem.create!(item: item1, invoice: invoice5)
		InvoiceItem.create!(item: item2, invoice: invoice5)
		InvoiceItem.create!(item: item2, invoice: invoice6)
		InvoiceItem.create!(item: item3, invoice: invoice6)

		InvoiceItem.create!(item: item5, invoice: invoice7)

		InvoiceItem.create!(item: item1, invoice: invoice8)
		InvoiceItem.create!(item: item3, invoice: invoice8)
		InvoiceItem.create!(item: item2, invoice: invoice9)
		InvoiceItem.create!(item: item3, invoice: invoice9)
		InvoiceItem.create!(item: item3, invoice: invoice10)
		InvoiceItem.create!(item: item4, invoice: invoice10)
		InvoiceItem.create!(item: item1, invoice: invoice11)
		InvoiceItem.create!(item: item4, invoice: invoice11)
		create(:shipped_invoice_items, item: item6, invoice: invoice1)

	end

  describe '#instance methods' do
    it '#top_five_customers' do
      expect(merchant1.top_five_customers).to eq([customer1, customer2, customer3, customer5, customer6])
    end

    it '#customer_successful_transactions(customer_id)' do
      expect(merchant1.customer_successful_transactions(customer1.id)).to eq(2)
      expect(merchant1.customer_successful_transactions(customer4.id)).to eq(1)
    end

		it '#ordered_items_not_yet_shipped' do 
			expect(merchant1.ordered_items_not_yet_shipped).to eq([item1, item2, item1, item4, item4, item3, item1, item4, item1, item2, item2, item3, item5, item1, item3, item2, item3, item3, item4, item1, item4])
			expect(merchant1.ordered_items_not_yet_shipped).to_not include(item6)
		end
  end

	describe 'class methods' do
		it '::active_merchants' do
			expect(Merchant.active_merchants).to eq([merchant1, merchant_2, merchant_3])

			merchant_4.update status: 0

			expect(Merchant.active_merchants).to eq([merchant1, merchant_2, merchant_3, merchant_4])
		end

		it '::disabled_merchants' do
			expect(Merchant.disabled_merchants).to eq([merchant_4])

			merchant_2.update status: 1

			expect(Merchant.disabled_merchants).to eq([merchant_4, merchant_2])
		end
	end
end
