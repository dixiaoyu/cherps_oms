class FeedbacksController < ApplicationController
  def index
    
  end
  
  def fbtype
    if params[:trans]=="trans"
      @type="trans"
    elsif params[:trans].nil?
      redirect_to feedback_path
    else
      @type="others"      
      @item=[]
    end
  end
  
  def transfeedback
    @item=CrmMemberTransaction.find_item(current_user.mbr_id,params[:select])
    @location=ImsLocationList.find_by_loc_id(@item[0].loc_id)
    @type="1"
  end
  
  def create_feedback
    line=Feedback.maximum("line_num")
    if line.nil?
      line_num="1"
    else
      line_num=line+1  
    end  
    if  !params[:id].nil?
      item=CrmMemberTransaction.find_item(current_user.mbr_id, params[:id])
      @feedback=Feedback.create(:coy_id=>"CTL",:line_num=>line_num, :feedback_type=>params[:type], :submit_date=>Time.now,
                                :mbr_id=>current_user.mbr_id, :visitor_name=>current_user.first_name,
                                :contact_num=>current_user.contact_num, :email_addr=>current_user.email_addr,
                                :visit_date=>Time.now, :receipt_id=>params[:id], :loc_id=>item[0].loc_id,
                                :feedback_text=>params[:feedbacks][:feedback_text],:created_by=>current_user.first_name,
                                :modified_by=>current_user.first_name, :modified_on=>Time.now)
    else
      @feedback=Feedback.create(:coy_id=>"CTL",:line_num=>line_num, :feedback_type=>params[:type], :submit_date=>Time.now,
                                :mbr_id=>current_user.mbr_id, :visitor_name=>current_user.first_name,
                                :contact_num=>current_user.contact_num, :email_addr=>current_user.email_addr,
                                :visit_date=>Time.now, :feedback_text=>params[:feedbacks][:feedback_text],:created_by=>current_user.first_name,
                                :modified_by=>current_user.first_name, :modified_on=>Time.now)
    end                            
    redirect_to thanks_path                          
  end
  

  
end
