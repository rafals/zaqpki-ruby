class AccountController < ApplicationController
  before_filter :login_required, :only => :dashboard
  def dashboard
    puts root_path
    feeds_per_page = 10
    @current_user = current_user
    @total_pages = (current_user.feeds.count.to_f / feeds_per_page).ceil
    @page = (params[:id] = params[:id].to_i) ? (params[:id] < 1 ? 1 : params[:id] > @total_pages ? @total_pages : params[:id]) : 1
    @feeds = Feed.find :all, :conditions => "account_id = " + current_user.id.to_s, :order => 'id DESC', :offset => (@page-1) * feeds_per_page, :limit => feeds_per_page
    @friends = current_user.friends.map { |friend| friend }
    @saldo = current_user.saldo
    if last_deal = Deal.find_all_by_sponsor_id(current_user.id).reverse[0]
      @defualt_spongers = last_deal.spongers
    end
    @display_new_deal = true
  end
  
  def login
    if user = Account.authenticate(params[:email], params[:password])
      session[:current_user] = user.id
      flash[:notice] = "Zalogowano"
      redirect_to :controller => 'account', :action => 'dashboard'
    else
      flash[:error] = "Nie zalogowano"
      redirect_to :controller => 'intro', :action => 'index'
    end
  end

  
  def logout
    session[:current_user] = nil
    redirect_to :controller => 'intro', :action => 'index'
  end
  
end