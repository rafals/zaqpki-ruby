class SignupController < ApplicationController
  
  before_filter :verify_required, :only => [:account_details_form, :create_account]
  
  def verify_required
    unless session[:verified_email]
      flash[:error] = "Niezweryfikowany adres e-mail"
      redirect_to '/'
    end
  end
  
  def send_authentication_email
    host = request.env['HTTP_HOST']
    if Account.find_by_email(params[:email])
      flash[:error] = "Konto z takim e-mailem istnieje!"
    elsif (activation = Activation.find_by_email(params[:email]) || Activation.create(:email => params[:email])).id
      puts activation.inspect
      mail = Activator.create_signup_token(activation, host)
      Activator.deliver(mail)
      flash[:notice] = "Ponownie wyslalismy ci email aktywacyjny"
    else
      flash[:error] = "Podano zly e-mail"
    end
    redirect_to '/'
  end
  
  def verify_authentication_token
    if activation = Activation.find_by_token(params[:token])
      session[:verified_email] = activation.email
      redirect_to signup_details_path
    else
      flash[:error] = "Niezweryfikowany adres e-mail"
      redirect_to '/'
    end
  end
  
  def details_form
  end
  
  def create_account
    unless params[:password] == params[:confirmation_password]
      flash[:error] = "Podane hasla nie sa identyczne!"
      redirect_to signup_details_path
    end
    account = Account.new :email => session[:verified_email], :password => params[:password], :name => params[:name]
    if account.save
      session[:current_user] = account.id
      Activation.find_by_email(session[:verified_email]).destroy
      flash[:notice] = "Konto stworzono"
      redirect_to dashboard_path
    else
      flash[:error] = account.errors.inspect.to_s
      redirect_to '/'
    end
  end
end