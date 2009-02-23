class AccountController < ApplicationController
  before_filter :login_required, :only => :dashboard
  def dashboard
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
  
  def send_authentication_email
    host = request.env['HTTP_HOST']
    if Account.find_by_email(params[:email])
      flash[:error] = "Konto z takim e-mailem istnieje!"
    elsif activation = Activation.find_by_email(params[:email])
      mail = Activator.create_signup_token(activation, host)
      Activator.deliver(mail)
      flash[:notice] = "ponownie wyslalismy ci email aktywacyjny"
    else
      activation = Activation.create(:email => params[:email])
      mail = Activator.create_signup_token(activation, host)
      Activator.deliver(mail)
      flash[:notice] = "wyslalismy ci email aktywacyjny"
    end
    redirect_to :controller => 'intro', :action => 'index'
  end
  
  def verify_authentication_token
    if activation = Activation.find_by_token(params[:token])
      session[:verified_email] = activation.email
      redirect_to :action => 'signup'
    else
      flash[:error] = "Niezweryfikowany adres e-mail"
      redirect_to :controller => 'intro', :action => 'index'
    end
  end
  
  def signup
    unless session[:verified_email]
      flash[:error] = "Niezweryfikowany adres e-mail"
      redirect_to :controller => 'intro', :action => 'index'
    end
  end
  
  def signup_finalize
    unless session[:verified_email]
      flash[:error] = "Niezweryfikowany adres e-mail"
      redirect_to :controller => 'intro', :action => 'index'
    end
    unless params[:password] == params[:confirmation_password]
      flash[:error] = "Podane hasla nie sa identyczne!"
      redirect_to :action => 'signup'
    end
    account = Account.new :email => session[:verified_email], :password => params[:password], :name => params[:name]
    if account.save
      session[:current_user] = user.id
      Activation.find_by_email(session[:verified_email]).destroy
      flash[:notice] = "Konto stworzono"
      redirect_to :action => 'dashboard'
    else
      flash[:error] = account.errors.inspect.to_s
      redirect_to :controller => 'intro', :action => 'index'
    end
  end
  
  def logout
    session[:current_user] = nil
    redirect_to :controller => 'intro', :action => 'index'
  end
  
end