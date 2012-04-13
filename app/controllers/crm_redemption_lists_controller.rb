class CrmRedemptionListsController < ApplicationController
  before_filter :authenticate
  before_filter :deny_operation, :only=>:show  
  def index  
    if params[:p1]=="0" && params[:p2]=="0"
      @redemptions = CrmRedemptionList.all
    elsif params[:p1]=="0" && params[:p2]=="250"
      @redemptions = CrmRedemptionList.find_through_points(0,250)
    elsif params[:p1]=="251" && params[:p2]=="500"
      @redemptions = CrmRedemptionList.find_through_points(251,500)
    elsif params[:p1]=="501" && params[:p2]=="750"
      @redemptions = CrmRedemptionList.find_through_points(501,750)   
    elsif params[:p1]=="751" && params[:p2]=="1000"
      @redemptions = CrmRedemptionList.find_through_points(751,1000)
    elsif params[:p1]=="1001" && params[:p2]=="999999"
      @redemptions = CrmRedemptionList.find_through_points(1001,999999)               
    end 
  end
  
  def show
    p=params[:p].to_i
    if p>=0 && p<=250
      @redemptions = CrmRedemptionList.find_through_points(0,250)
    elsif p>=251 && p<=500
      @redemptions = CrmRedemptionList.find_through_points(251,500)  
    elsif p>= 501 && p<=750
      @redemptions = CrmRedemptionList.find_through_points(501,750)
    elsif p>=751 && p<=1000
      @redemptions = CrmRedemptionList.find_through_points(751,1000)  
    elsif p>= 1001 && p<=999999
      @redemptions = CrmRedemptionList.find_through_points(1001,999999)
    end  
    #@redemptions = CrmRedemptionList.all
    @redemption = CrmRedemptionList.find_by_id(params[:id])
    #@locations = CrmRedemptionLocation.find_by_sql("select * from crm_redemption_location where item_id = ?",@redemption.item_id)    
    item_id = @redemption.item_id
    @locations = CrmRedemptionLocation.find_through_item_id(item_id)
  end 
  
 
end
