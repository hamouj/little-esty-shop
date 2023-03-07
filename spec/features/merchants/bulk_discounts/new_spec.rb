require 'rails_helper'

describe 'As a Merchant', type: :feature do
  before(:each) do
    @merchant_1 = create(:merchant)
    @bulk_discount_1 = create(:bulk_discount, merchant: @merchant_1)
  end

  describe 'When I visit the new merchant bulk discount page' do
    it 'links from the merchant bulk discount index page' do
      visit merchant_bulk_discounts_path(@merchant_1)

      within '#add_discount' do
        click_link "Create a New Discount"
      end

      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_1))
    end

    it 'I see a form to add a new bulk discount' do
      visit "/merchants/#{@merchant_1.id}/bulk_discounts/new"

      expect(page).to have_field :bulk_discount_name
      expect(page).to have_field :bulk_discount_percent_discount
      expect(page).to have_field :bulk_discount_quantity_threshold
      expect(page).to have_button 'Add Discount'
    end

    it 'When I partially fill in the form and submit, I am redirected back to the new merchant bulk discount page' do
      visit "/merchants/#{@merchant_1.id}/bulk_discounts/new"

      fill_in :bulk_discount_percent_discount, with: 25
      click_button "Add Discount"

      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_1))
    end

    it 'When I partially fill in the form and submit, I get a message stating what I need to fix' do
      visit "/merchants/#{@merchant_1.id}/bulk_discounts/new"

      fill_in :bulk_discount_percent_discount, with: 25
      click_button "Add Discount"

      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_1))
      expect(page).to have_content("Quantity threshold can't be blank, Quantity threshold is not a number, Name can't be blank")
    end

    it 'When I fill in the form with the incorrect data type and submit, I get a message stating what I need to fix' do
      visit "/merchants/#{@merchant_1.id}/bulk_discounts/new"

      fill_in :bulk_discount_percent_discount, with: "J"
      fill_in :bulk_discount_quantity_threshold, with: 3
      click_button "Add Discount"

      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_1))
      expect(page).to have_content("Percent discount is not a number")
    end

    it 'When I fill in the form with valid data and submit, I am redirected to the bulk discount index where I see my new bulk discount listed' do
      visit "/merchants/#{@merchant_1.id}/bulk_discounts/new"

      fill_in :bulk_discount_name, with: '20off4'
      fill_in :bulk_discount_percent_discount, with: 25
      fill_in :bulk_discount_quantity_threshold, with: 5
      click_button "Add Discount"

      new_discount = BulkDiscount.last

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1))
      expect(page).to have_content("#{new_discount.percent_discount}% off #{new_discount.quantity_threshold} items")
    end
  end
end