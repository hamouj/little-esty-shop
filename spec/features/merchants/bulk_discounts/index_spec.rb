require 'rails_helper' 


describe 'As a Merchant', type: :feature do
  before(:each) do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)

    @bulk_discount_1 = create(:bulk_discount, merchant: @merchant_1)
    @bulk_discount_2 = create(:bulk_discount, merchant: @merchant_1)
    @bulk_discount_3 = create(:bulk_discount, merchant: @merchant_1)
    @bulk_discount_4 = create(:bulk_discount, merchant: @merchant_1)
    @bulk_discount_5 = create(:bulk_discount, merchant: @merchant_2)
  end
  
  describe 'When I visit my merchant bulk discount index page' do
    it 'links from the merchant dashboard' do
      visit merchant_path(@merchant_1)

      click_link "Merchant Discounts"

      expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts")
    end

    it 'I see all of my bulk discounts including their percentage discount and quantity thresholds' do
      visit merchant_bulk_discounts_path(@merchant_1)

      within '#bulk_discounts' do 
        expect(page).to have_content("#{@bulk_discount_1.percent_discount}% off #{@bulk_discount_1.quantity_threshold} items")
        expect(page).to have_content("#{@bulk_discount_2.percent_discount}% off #{@bulk_discount_2.quantity_threshold} items")
        expect(page).to have_content("#{@bulk_discount_3.percent_discount}% off #{@bulk_discount_3.quantity_threshold} items")
        expect(page).to have_content("#{@bulk_discount_4.percent_discount}% off #{@bulk_discount_4.quantity_threshold} items")
        expect(page).to_not have_content("#{@bulk_discount_5.percent_discount}% off #{@bulk_discount_5.quantity_threshold} items")
      end
    end

    it 'each discount includes a link to its show page' do
      visit merchant_bulk_discounts_path(@merchant_1)

      within '#bulk_discounts' do
        expect(page).to have_link("#{@bulk_discount_1.id}")
        expect(page).to have_link("#{@bulk_discount_2.id}")
        expect(page).to have_link("#{@bulk_discount_3.id}")
        expect(page).to have_link("#{@bulk_discount_4.id}")
        expect(page).to_not have_link("#{@bulk_discount_5.id}")

        click_link "#{@bulk_discount_1.id}"
      end

      expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts/#{@bulk_discount_1.id}")
    end

    it 'I see a link to create a new discount' do
      visit merchant_bulk_discounts_path(@merchant_1)

      within '#add_discount' do
        expect(page).to have_link("Create a New Discount", href: new_merchant_bulk_discount_path(@merchant_1))
        click_link "Create a New Discount"
      end

      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_1))
    end

    it 'Next to each bulk discount I see a link to delete it' do
      visit merchant_bulk_discounts_path(@merchant_1)

      within '#bulk_discounts' do
        expect(page).to have_link("Delete #{@bulk_discount_1.id}")
        expect(page).to have_link("Delete #{@bulk_discount_2.id}")
        expect(page).to have_link("Delete #{@bulk_discount_3.id}")
        expect(page).to have_link("Delete #{@bulk_discount_4.id}")
      end
    end
    
    it 'When I click the delete link, I am redirected back to the bulk discounts index page and I no longer see the discount listed' do
      visit merchant_bulk_discounts_path(@merchant_1)

      within '#bulk_discounts' do
        expect(page).to have_content("#{@bulk_discount_2.percent_discount}% off #{@bulk_discount_2.quantity_threshold} items")
      
        click_link "Delete #{@bulk_discount_2.id}"
      end

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1))
      
      within '#bulk_discounts' do
        expect(page).to have_content("#{@bulk_discount_1.percent_discount}% off #{@bulk_discount_1.quantity_threshold} items")
        expect(page).to have_content("#{@bulk_discount_3.percent_discount}% off #{@bulk_discount_3.quantity_threshold} items")
        expect(page).to have_content("#{@bulk_discount_4.percent_discount}% off #{@bulk_discount_4.quantity_threshold} items")
        expect(page).to_not have_content("#{@bulk_discount_2.percent_discount}% off #{@bulk_discount_2.quantity_threshold} items")
      end
    end
  end
end