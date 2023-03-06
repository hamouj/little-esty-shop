class Merchant::BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = @merchant.bulk_discounts
    @upcoming_holidays = HolidaySearch.new.upcoming_holidays
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.new
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    new_discount = merchant.bulk_discounts.new(bulk_discount_params)
    
    if new_discount.save
      redirect_to merchant_bulk_discounts_path(merchant)
    else
      flash[:notice] = error_message(new_discount.errors)
      redirect_to new_merchant_bulk_discount_path(merchant)
    end
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = BulkDiscount.find(params[:id])

    bulk_discount.update(bulk_discount_params)

    redirect_to merchant_bulk_discount_path(merchant, bulk_discount)
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id]) 

    BulkDiscount.destroy(params[:id])

    redirect_to merchant_bulk_discounts_path(merchant)
  end

private
  def bulk_discount_params
    params.require(:bulk_discount).permit(:percent_discount, :quantity_threshold, :merchant_id)
  end
end