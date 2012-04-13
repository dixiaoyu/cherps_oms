class ImsInvPhysicalsController < ApplicationController
  before_filter :authenticate
  #before_filter :check_expiration  
  def index
    #@quantity = params[:order] 
    #@redeem_id = params[:id]
    @quantity = params[:quantity]
    @item_id = params[:redeem_id]
    @type=params[:type]
    if @quantity.empty? 
      if @type=="redemption"     
        redirect_to redeemdetails_path(:id=>params[:redeem_id],:p=>params[:points],:q=>"0")
      elsif @type=="product"
        redirect_to productdetail_path(:c=>params[:category],:id=>params[:redeem_id],:q=>"0")
      end
    else      
      if @type=="product"
        @item=CrmProductList.find_by_id(@item_id)
      elsif @type=="redemption"
        @item = CrmRedemptionList.find_by_id(@item_id)  
      end
      #@redemption = CrmRedemptionList.find_by_id(@redeem_id)
      
      #item_id = @redemption.item_id
      #@locations =  CrmRedemptionLocation.find_through_item_id(item_id)  
             
      @locations =  ImsInvPhysical.find_through_item_id(@item.item_id)      
      #@locations =  ImsInvPhysical.find_by_item_id(@item_id)  
    end 
    
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
