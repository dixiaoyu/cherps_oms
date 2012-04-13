class CrmRedemptionLocationsController < ApplicationController
  before_filter :authenticate
  #before_filter :check_expiration  
  def index
    @quantity = params[:order] 
    @redeem_id = params[:id]
    @redemption = CrmRedemptionList.find_by_id(@redeem_id)
    item_id = @redemption.item_id
    @locations =  CrmRedemptionLocation.find_through_item_id(item_id)     
  end
  
  def create
    quantity = params[:quantity].to_i 
    redeem_id = params[:redeem_id]
    if quantity.nil? || quantity.to_i<1
      redirect_to redeemdetails_path(:id=>redeem_id), :notice => "Quantity ordered must be more than one."
    else
      redirect_to location_path(:order=>quantity, :id=> redeem_id)
    end  
  end
end  

