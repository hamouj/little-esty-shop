require 'rails_helper'

describe 'As a merchant', type: :feature do
  before(:each) do
    @merchant_1 = create(:merchant)

    @bulk_discount_1 = create(:bulk_discount, merchant: @merchant_1)
  end

  describe 'When I visit the bulk discount edit page' do
    it 'links from the bulk discount show page' do
      visit merchant_bulk_discount_path(@merchant_1, @bulk_discount_1)

      click_link "Edit Discount"

      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant_1, @bulk_discount_1))
    end

    it 'I see a form to edit the discount and the current attributes are pre-populated in the form' do
      visit edit_merchant_bulk_discount_path(@merchant_1, @bulk_discount_1)

      expect(page).to have_field(:bulk_discount_name, with: @bulk_discount_1.name) 
      expect(page).to have_field(:bulk_discount_percent_discount, with: @bulk_discount_1.percent_discount) 
      expect(page).to have_field(:bulk_discount_quantity_threshold, with: @bulk_discount_1.quantity_threshold)
      expect(page).to have_button("Edit Discount")
    end

    it 'When I change ANY of the information and click submit, I am redirected to the bulk discount show page and I see that the attributes have been updated' do
      visit edit_merchant_bulk_discount_path(@merchant_1, @bulk_discount_1)

      fill_in :bulk_discount_percent_discount, with: 45
      click_button "Edit Discount"

      expect(current_path).to eq(merchant_bulk_discount_path(@merchant_1, @bulk_discount_1))
      expect(page).to have_content("45% off #{@bulk_discount_1.quantity_threshold} items")
    end

    it 'When I change ALL of the information and click submit, I am redirected to the bulk discount show page and I see that the attributes have been updated' do
      visit edit_merchant_bulk_discount_path(@merchant_1, @bulk_discount_1)

      fill_in :bulk_discount_name, with: '30off3'
      fill_in :bulk_discount_percent_discount, with: 45
      fill_in :bulk_discount_quantity_threshold, with: 30
      click_button "Edit Discount"

      expect(page).to have_content("45% off 30 items")
      expect(page).to have_content('30off3')
    end

    it 'When I change NONE of the information and click submit, I am redirected to the bulk discount show page and I see that the attributes have not changed' do
      visit edit_merchant_bulk_discount_path(@merchant_1, @bulk_discount_1)

      click_button "Edit Discount"

      expect(page).to have_content("#{@bulk_discount_1.percent_discount}% off #{@bulk_discount_1.quantity_threshold} items")
      expect(page).to have_content("#{@bulk_discount_1.name}")
    end
  end
end