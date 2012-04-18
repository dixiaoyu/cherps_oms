class CrmProductReservationsController < ApplicationController
  before_filter :authenticate
  #before_filter :deny_operation, :except=>[:index, :rebate]
  def index   
    #@reservations = current_user.crm_redemption_reservations
    mbr_id = current_user.mbr_id    
    #@reservations = CrmProductReservation.find_through_id_status(mbr_id, 0)
    @product_reservations = CrmProductReservation.find_through_id_status(mbr_id, 0)
  end
  
  def show
    @product = CrmProductList.find(params[:product_list_id])
    @reservation = @product.crm_product_reservations.find(params[:id])
    @location = ImsLocationList.find_by_loc_id(@reservation.loc_id)
    @address = CoyAddressBook.get_address("LOCATION", @location.loc_id, "0-PRIMARY")
  end
  
  def create
    @product = CrmProductList.find(params[:crm_product_list_id])  
    #points=current_user.points_accumulated-current_user.points_redeemed-current_user.points_reserved
    if params[:location].nil?
      redirect_to productdetail_path(:c=>params[:category],:id=>@product.id,:l=>"0")
    #elsif points < params[:quantity].to_f * @redemption.points_required       
    #  redirect_to @redemption, :notice => "Sorry, your points are not enough for redemption." 
    else
      line=CrmProductReservation.maximum("line_num")
      if line.nil?
        line_num=1
      else
        line_num=line+1  
      end 
     
      @reservation = @product.crm_product_reservations.create(:coy_id=>"CTL", :mbr_id => current_user.mbr_id, :item_id => @product.item_id, :loc_id => params[:location], :item_desc => @product.item_desc, 
                                                                    :qty_reserved => params[:quantity].to_f, :date_reserved => Time.now,:valid_until => 7.days.from_now,
                                                                    :crm_member_list_id => current_user.id, :status_level => 0, :crm_product_list_id=>@product.id, :line_num=>line_num, :created_by=>current_user.first_name,
                                                                    :modified_by=>current_user.first_name, :modified_on=>Time.now)   
      
      #points_acc = current_user.points_accumulated - params[:quantity].to_f * @redemption.points_required
      #points_res = current_user.points_reserved + params[:quantity].to_f * @redemption.points_required
     
      #current_user.update_attributes(:points_reserved => points_res)
      
      item_id = @product.item_id
      loc_id = params[:location]
      coy_id = "CTL"
      #locations = CrmRedemptionLocation.find_through_loc_item(loc_id,item_id,coy_id)
      locations = ImsInvPhysical.find_through_loc_item(loc_id,item_id,coy_id)
      location = locations[0]
      qty_on_hand = location.qty_on_hand - params[:quantity].to_f
      qty_reserved = location.qty_reserved + params[:quantity].to_f
      location.update_attributes(:qty_on_hand => qty_on_hand, :qty_reserved => qty_reserved, :created_by=>current_user.first_name,
                                 :modified_by=>current_user.first_name, :modified_on=>Time.now)      
            
      redirect_to productreserve_path(:product_list_id=>@product.id, :id=>@reservation.id)    
    end
  end
  
  
  def destroy  
    #if r==true 
    @reservation = CrmProductReservation.find(params[:id])   
    @reservation.update_attributes(:status_level => -2,:created_by=>current_user.first_name,
                                                                    :modified_by=>current_user.first_name, :modified_on=>Time.now)   
    
    #points_acc = current_user.points_accumulated + params[:qty].to_f * @reservation.crm_redemption_list.points_required
    #points_res = current_user.points_reserved - params[:qty].to_f * @reservation.crm_redemption_list.points_required
   
    #current_user.update_attributes(:points_reserved => points_res)    
        
    locations = ImsInvPhysical.find_through_loc_item(@reservation.loc_id,@reservation.item_id,@reservation.coy_id)
    location = locations[0]
    qty_on_hand=locations[0].qty_on_hand+@reservation.qty_reserved
    qty_reserved=locations[0].qty_reserved-@reservation.qty_reserved
    location.update_attributes(:qty_on_hand => qty_on_hand, :qty_reserved => qty_reserved, :created_by=>current_user.first_name,
                               :modified_by=>current_user.first_name, :modified_on=>Time.now)
    #@reservation.destroy
    redirect_to redeemhistory_path 
    #end
  end
  
  def rebate
    max_id=CrmRedemptionReservation.maximum("id")
    line_num=CrmRedemptionReservation.maximum("line_num")
    @reservation=CrmRedemptionReservation.create(:id=>max_id+1,:coy_id=>"CTL", :mbr_id=>current_user.mbr_id,
                                                :line_num=>line_num+1, :item_id=>"!VCH-REBATE", :item_desc=>"Rebate Voucher",
                                                :qty_reserved=>1, :date_reserved=>Time.now, :valid_until=>7.days.from_now,
                                                :status_level=>1, :crm_member_list_id=>current_user.id, :crm_redemption_list_id=>"1", 
                                                :created_by=>current_user.first_name, :modified_by=>current_user.first_name,
                                                :modified_on=>Time.now)                                                     
  end
end
