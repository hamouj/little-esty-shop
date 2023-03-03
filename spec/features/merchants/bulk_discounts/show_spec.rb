require 'rails_helper'

describe 'As a merchant', type: :feature do
  before(:each) do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)

    @bulk_discount_1 = create(:bulk_discount, merchant: @merchant_1)
    @bulk_discount_2 = create(:bulk_discount, merchant: @merchant_1)
    @bulk_discount_3 = create(:bulk_discount, merchant: @merchant_1)
    @bulk_discount_4 = create(:bulk_discount, merchant: @merchant_1)
    @bulk_discount_5 = create(:bulk_discount, merchant: @merchant_2)
  end

  describe 'When I visit my bulk discount show page' do
    it 'links from the merchant bulk discount index page' do
      visit merchant_bulk_discounts_path(@merchant_1)

      click_link "#{@bulk_discount_2.id}"

      expect(current_path).to eq(merchant_bulk_discount_path(@merchant_1, @bulk_discount_2))
    end
  end
end