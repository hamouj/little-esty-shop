class MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
  end
  
  def show
    @merchant = Merchant.find(params[:id])
    @invoices = @merchant.invoices
  end
end