class  Merchant::InvoicesController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @invoices = @merchant.invoices
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @invoice = Invoice.find(params[:id])
    @total_revenue = @invoice.merchant_total_revenue(@merchant)
    @discounted_revenue = @invoice.merchant_discounted_revenue(@merchant)
  end
end