 # Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  layout 'github'
  
  def current_user
    return nil unless session[:current_user]
    @current_user ||= Account.find session[:current_user]
  end
  
  def login_required
    unless current_user
      flash[:error] = "Nie zalogowano!"
      redirect_to '/'
    end
  end
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery # :secret => 'ffd6010ea2a4ef9111f1499dab1de36a'
end
