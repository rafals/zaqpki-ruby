# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  layout 'oldschool'
  def current_user
    @current_user
  end

  def login
    @current_user = Account.find 2
  end
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery # :secret => 'ffd6010ea2a4ef9111f1499dab1de36a'
end
