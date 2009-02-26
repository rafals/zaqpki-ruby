class DealsController < ApplicationController
  before_filter :login_required 
  
  def add
    current_user.report params[:description], params[:cost], params[:spongers_ids].split(','), params[:sponsor_id]#.split(',')
    flash[:notice] = "Zaqpiono " + params[:description]
    redirect_to '/'
  end
  
  def remove
    if Deal.find(params[:id]).disable_by current_user
      flash[:notice] = "Wyjebka udana!^_^"
    else
      flash[:error] = "Nie udało się wyjebać deala"
    end
    redirect_to '/'
  end
end