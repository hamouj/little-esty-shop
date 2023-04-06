require 'rails_helper' 

describe 'As a Merchant', type: :feature do
  let!(:upcoming_holidays) { HolidaySearch.new.upcoming_holidays }

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

      within "##{@bulk_discount_1.id}" do 
        expect(page).to have_content("#{@bulk_discount_1.percent_discount}% off #{@bulk_discount_1.quantity_threshold} items")
      end

      within "##{@bulk_discount_2.id}" do 
        expect(page).to have_content("#{@bulk_discount_2.percent_discount}% off #{@bulk_discount_2.quantity_threshold} items")
      end

      within "##{@bulk_discount_3.id}" do 
        expect(page).to have_content("#{@bulk_discount_3.percent_discount}% off #{@bulk_discount_3.quantity_threshold} items")
      end

      within "##{@bulk_discount_4.id}" do 
        expect(page).to have_content("#{@bulk_discount_4.percent_discount}% off #{@bulk_discount_4.quantity_threshold} items")
      end

      expect(page).to_not have_content("#{@bulk_discount_5.percent_discount}% off #{@bulk_discount_5.quantity_threshold} items")
    end

    it 'each discount includes a link to its show page' do
      visit merchant_bulk_discounts_path(@merchant_1)

      within "##{@bulk_discount_1.id}" do 
        expect(page).to have_link("#{@bulk_discount_1.name}")
      end

      within "##{@bulk_discount_2.id}" do 
        expect(page).to have_link("#{@bulk_discount_2.name}")
      end

      within "##{@bulk_discount_3.id}" do 
        expect(page).to have_link("#{@bulk_discount_3.name}")
      end

      within "##{@bulk_discount_4.id}" do 
        expect(page).to have_link("#{@bulk_discount_4.name}")
      end

      click_link "#{@bulk_discount_1.name}"

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

      within "##{@bulk_discount_1.id}" do 
        expect(page).to have_link("Delete #{@bulk_discount_1.name}")
      end

      within "##{@bulk_discount_2.id}" do 
        expect(page).to have_link("Delete #{@bulk_discount_2.name}")
      end

      within "##{@bulk_discount_3.id}" do 
        expect(page).to have_link("Delete #{@bulk_discount_3.name}")
      end

      within "##{@bulk_discount_4.id}" do 
        expect(page).to have_link("Delete #{@bulk_discount_4.name}")
      end
    end
    
    it 'When I click the delete link, I am redirected back to the bulk discounts index page and I no longer see the discount listed' do
      visit merchant_bulk_discounts_path(@merchant_1)

      within "##{@bulk_discount_2.id}" do 
        expect(page).to have_content("#{@bulk_discount_2.percent_discount}% off #{@bulk_discount_2.quantity_threshold} items")
      
        click_link "Delete #{@bulk_discount_2.name}"
      end

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1))
      expect(page).to_not have_content("#{@bulk_discount_2.percent_discount}% off #{@bulk_discount_2.quantity_threshold} items")
    end

    it 'I see a section with a header of Upcoming Holidays and the name/date of the next 3 US holidays' do
      visit merchant_bulk_discounts_path(@merchant_1)

      within '#upcoming_holidays' do
        expect(page).to have_content("Upcoming Holidays")
        expect(page).to have_content("#{upcoming_holidays.first.name} - #{upcoming_holidays.first.date}")
        expect(page).to have_content("#{upcoming_holidays.second.name} - #{upcoming_holidays.second.date}")
        expect(page).to have_content("#{upcoming_holidays.last.name} - #{upcoming_holidays.last.date}")
      end
    end

    it 'In the Holiday Discounts section, I see a create discount button next to each of the 3 upcoming holidays' do
      visit merchant_bulk_discounts_path(@merchant_1)

      within "##{upcoming_holidays.first.name.gsub(/\s+/, "")}" do
        expect(page).to have_link("Create Discount", href: "/merchants/#{@merchant_1.id}/bulk_discounts/new?holiday=#{upcoming_holidays.first.name}")
      end

      within "##{upcoming_holidays.second.name.gsub(/\s+/, "")}" do
        expect(page).to have_link("Create Discount", href: "/merchants/#{@merchant_1.id}/bulk_discounts/new?holiday=#{upcoming_holidays.second.name}")
      end

      within "##{upcoming_holidays.third.name.gsub(/\s+/, "")}" do
        expect(page).to have_link("Create Discount", href: "/merchants/#{@merchant_1.id}/bulk_discounts/new?holiday=#{upcoming_holidays.third.name}")
      end
    end

    it 'When I click on the button, I am taken to a new discount form' do
      visit merchant_bulk_discounts_path(@merchant_1)

      within "##{upcoming_holidays.first.name.gsub(/\s+/, "")}" do
        click_link "Create Discount"
      end

      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_1))
    end
  end
end