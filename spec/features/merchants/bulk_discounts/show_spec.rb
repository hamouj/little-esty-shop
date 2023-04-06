require 'rails_helper'

describe 'As a merchant', type: :feature do
  before(:each) do
    @merchant_1 = create(:merchant)

    @bulk_discount_1 = create(:bulk_discount, merchant: @merchant_1)
    @bulk_discount_2 = create(:bulk_discount, merchant: @merchant_1)
  end

  describe 'When I visit my bulk discount show page' do
    it 'links from the merchant bulk discount index page' do
      visit merchant_bulk_discounts_path(@merchant_1)

      click_link "#{@bulk_discount_2.name}"

      expect(current_path).to eq(merchant_bulk_discount_path(@merchant_1, @bulk_discount_2))
    end

    it "I see the bulk discount's quantity threshold and percentage discount" do
      visit merchant_bulk_discount_path(@merchant_1, @bulk_discount_1)

      expect(page).to have_content("#{@bulk_discount_1.percent_discount}% off #{@bulk_discount_1.quantity_threshold} items")
      expect(page).to_not have_content("#{@bulk_discount_2.percent_discount}% off #{@bulk_discount_2.quantity_threshold} items")
    end

    it 'I see a link to edit the bulk discount' do
      visit merchant_bulk_discount_path(@merchant_1, @bulk_discount_1)

      expect(page).to have_link("Edit Discount", href: edit_merchant_bulk_discount_path(@merchant_1, @bulk_discount_1))

      click_link "Edit Discount"

      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant_1, @bulk_discount_1))
    end
  end
end