class CrmWorkshopReservationsController < ApplicationController

  def show
    @workshop = CrmWorkshopList.find(params[:workshop_list_id])
    @reservation = @workshop.crm_workshop_reservations.find(params[:id])
  end
  
  def create    
    @workshop=CrmWorkshopList.find_by_id(params[:crm_workshop_list_id])
    
    line=CrmWorkshopReservation.maximum("line_num")
    if line.nil?
      line_num=1
    else
      line_num=line+1  
    end      
    @reservation = @workshop.crm_workshop_reservations.create(:coy_id=>"CTL", :mbr_id => current_user.mbr_id, :line_num=>line_num,  :workshop_id => @workshop.workshop_id, 
                                                              :date_reserved => Time.now, :crm_member_list_id => current_user.id,:crm_workshop_list_id=>@workshop.id,:created_by=>current_user.first_name,
                                                              :modified_by=>current_user.first_name, :modified_on=>Time.now )   
    redirect_to workshopreserve_path(:workshop_list_id=>@workshop.id, :id=>@reservation.id)
  end
  
  def destroy
    @worksho_reservation=CrmWorkshopReservation.find_by_id(params[:id])
    @worksho_reservation.destroy    
    redirect_to redeemhistory_path 
  end
  
end
