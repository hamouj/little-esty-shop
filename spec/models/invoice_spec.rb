require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items)}
    it { should define_enum_for(:status).with_values(["cancelled", "in progress", "completed"])}
  end
end