require 'rails_helper'

describe BulkDiscount, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many(:items).through(:merchant) }
    it { should have_many(:invoice_items).through(:items) }
    it { should validate_presence_of :percent_discount }
    it { should validate_numericality_of :percent_discount }
    it { should validate_presence_of :quantity_threshold }
    it { should validate_numericality_of :quantity_threshold }
  end
end