require 'rails_helper'

RSpec.describe 'merchant show dashboard page', type: :feature do
  describe "as a merchant visiting '/merchants/merchant_id/dashboard'" do
    let!(:merchant1) { create(:merchant)}

    let!(:customer1) { create(:customer)}
    let!(:customer2) { create(:customer)}
    let!(:customer3) { create(:customer)}
    let!(:customer4) { create(:customer)}
    let!(:customer5) { create(:customer)}
    let!(:customer6) { create(:customer)}
  
    let!(:invoice1) { create(:completed_invoice, customer: customer1, created_at: Date.new(2014, 3, 1))}
    let!(:invoice2) { create(:completed_invoice, customer: customer1,  created_at: Date.new(2012, 3, 1))}
    let!(:invoice3) { create(:completed_invoice, customer: customer2)} 
    let!(:invoice4) { create(:completed_invoice, customer: customer2)}
    let!(:invoice5) { create(:completed_invoice, customer: customer3)}
    let!(:invoice6) { create(:completed_invoice, customer: customer3)}
    let!(:invoice7) { create(:completed_invoice, customer: customer4)}
    let!(:invoice8) { create(:completed_invoice, customer: customer5)}
    let!(:invoice9) { create(:completed_invoice, customer: customer5)}
    let!(:invoice10) { create(:completed_invoice, customer: customer6)}
    let!(:invoice11) { create(:completed_invoice, customer: customer6)}

    let!(:item1) {create(:item, merchant: merchant1)}  
    let!(:item2) {create(:item, merchant: merchant1)}
    let!(:item3) {create(:item, merchant: merchant1)}
    let!(:item4) {create(:item, merchant: merchant1)}
    let!(:item5) {create(:item, merchant: merchant1)}
   
    let!(:transaction1) {create(:transaction, invoice: invoice1) }
    let!(:transaction2) {create(:transaction, invoice: invoice2) }
    let!(:transaction3) {create(:transaction, invoice: invoice3) }
    let!(:transaction4) {create(:transaction, invoice: invoice4) }
    let!(:transaction5) {create(:transaction, invoice: invoice5) }
    let!(:transaction6) {create(:transaction, invoice: invoice6) }
    let!(:transaction8) {create(:transaction, invoice: invoice7) }
    let!(:transaction9) {create(:transaction, invoice: invoice8) }
    let!(:transaction10) {create(:transaction, invoice: invoice9) }
    let!(:transaction11) {create(:transaction, invoice: invoice10) }
    let!(:transaction12) {create(:transaction, invoice: invoice10) }
    let!(:transaction13) {create(:transaction, invoice: invoice11) }
    
    before do
      create(:invoice_item, item: item1, invoice: invoice1)
      create(:invoice_item, item: item2, invoice: invoice1)
      create(:invoice_item, item: item1, invoice: invoice2)
      create(:invoice_item, item: item4, invoice: invoice2)
      create(:invoice_item, item: item4, invoice: invoice3)
      create(:invoice_item, item: item3, invoice: invoice3)
      create(:invoice_item, item: item1, invoice: invoice4)
      create(:invoice_item, item: item4, invoice: invoice4)
      create(:invoice_item, item: item1, invoice: invoice5)
      create(:invoice_item, item: item2, invoice: invoice5)
      create(:invoice_item, item: item2, invoice: invoice6)
      create(:invoice_item, item: item3, invoice: invoice6)
      
      create(:invoice_item, item: item5, invoice: invoice7)

      create(:invoice_item, item: item1, invoice: invoice8)
      create(:invoice_item, item: item3, invoice: invoice8)
      create(:invoice_item, item: item2, invoice: invoice9)
      create(:invoice_item, item: item3, invoice: invoice9)
      create(:invoice_item, item: item3, invoice: invoice10)
      create(:invoice_item, item: item4, invoice: invoice10)
      create(:invoice_item, item: item1, invoice: invoice11)
      create(:invoice_item, item: item4, invoice: invoice11)

    end
  
    it 'shows my name(merchant)' do
      visit "/merchants/#{merchant1.id}/dashboard"

      expect(page).to have_content("#{merchant1.name}")
    end

    it "will have a link that takes me to the 'merchants/merchant_id/items index page" do 

      visit "/merchants/#{merchant1.id}/dashboard"

      expect(page).to have_link("Merchant Items")

      click_link("Merchant Items")

      expect(current_path).to eq("/merchants/#{merchant1.id}/items")
    end

    it "will have a link that takes me to the 'merchants/merchant_id/invoices index page" do 

      visit "/merchants/#{merchant1.id}/dashboard"

      expect(page).to have_link("Merchant Invoices")

      click_link("Merchant Invoices")

      expect(current_path).to eq("/merchants/#{merchant1.id}/invoices")
    end 

    it 'shows the names of the top 5 customers(largest number of successful transactions with merchant) and the number of transactions conducted with merchant' do
      visit "/merchants/#{merchant1.id}/dashboard"

      expect(page).to have_content("Top 5 customers with largest transactions")
      expect(page).to have_content("#{customer1.first_name} #{customer1.last_name}- number of transactions: #{merchant1.customer_successful_transactions(customer1.id)}")
      expect(page).to have_content("#{customer2.first_name} #{customer2.last_name}- number of transactions: #{merchant1.customer_successful_transactions(customer2.id)}")
      expect(page).to have_content("#{customer3.first_name} #{customer3.last_name}- number of transactions: #{merchant1.customer_successful_transactions(customer3.id)}")
      expect(page).to have_content("#{customer5.first_name} #{customer5.last_name}- number of transactions: #{merchant1.customer_successful_transactions(customer5.id)}")
      expect(page).to have_content("#{customer6.first_name} #{customer6.last_name}- number of transactions: #{merchant1.customer_successful_transactions(customer6.id)}")
      expect(page).to_not have_content("#{customer4.first_name} #{customer4.last_name}")
    end

    it 'will have a section called Items ready to ship, where there will be a list of the name of items that have been ordered, but not yet shipped' do 
      visit "/merchants/#{merchant1.id}/dashboard"

      create(:packaged_invoice_items, item: item1, invoice: invoice1)
      create(:packaged_invoice_items, item: item1, invoice: invoice1)
      create(:shipped_invoice_items, item: item1, invoice: invoice1)

      expect(page).to have_content("Items Ready to Ship")
      expect(page).to have_content(item1.name, count: 6)
      expect(page).to have_content(item2.name, count: 4)
      expect(page).to have_content(item3.name, count: 5)
      expect(page).to have_content(item4.name, count: 5)
      expect(page).to have_content(item5.name, count: 1)
    end

    it 'will have a link that named the invoice id for that item next to each item' do 
      visit "/merchants/#{merchant1.id}/dashboard"
    
      expect(page).to have_content("#{item1.name} - invoice # #{invoice1.id}")
      expect(page).to have_content("#{item1.name} - invoice # #{invoice2.id}")
      expect(page).to have_content("#{item2.name} - invoice # #{invoice5.id}")
      expect(page).to have_content("#{item2.name} - invoice # #{invoice1.id}")
      expect(page).to have_content("#{item3.name} - invoice # #{invoice3.id}")
      expect(page).to have_content("#{item3.name} - invoice # #{invoice6.id}")
      expect(page).to have_content("#{item4.name} - invoice # #{invoice3.id}")
      expect(page).to have_content("#{item4.name} - invoice # #{invoice4.id}")
      expect(page).to have_content("#{item5.name} - invoice # #{invoice7.id}")
    end

    it 'will have the invoices sorted by oldest to newest, with dates next to each invoice' do
      visit "/merchants/#{merchant1.id}/dashboard"
   
      expect("#{invoice2.id}").to appear_before("#{invoice1.id}")
      expect("#{invoice1.id}").to appear_before("#{invoice3.id}")
      expect("#{invoice3.id}").to appear_before("#{invoice4.id}")
      expect("#{invoice4.id}").to appear_before("#{invoice5.id}")
      expect("#{invoice5.id}").to appear_before("#{invoice6.id}")
      expect("#{invoice6.id}").to appear_before("#{invoice7.id}")
    end

		it 'shows the date the invoice was created' do
      visit "/merchants/#{merchant1.id}/dashboard"
   
      expect(page).to have_content(invoice1.created_at.strftime"%A, %B %d, %Y")
      expect(page).to have_content(invoice2.created_at.strftime"%A, %B %d, %Y")
      expect(page).to have_content(invoice3.created_at.strftime"%A, %B %d, %Y")
      expect(page).to have_content(invoice4.created_at.strftime"%A, %B %d, %Y")
      expect(page).to have_content(invoice5.created_at.strftime"%A, %B %d, %Y")
      expect(page).to have_content(invoice6.created_at.strftime"%A, %B %d, %Y")
    end
  end
end