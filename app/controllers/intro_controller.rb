class IntroController < ApplicationController
  def index
    render_component :controller => 'account', :action => 'dashboard' if current_user
  end

  def error404
    flash[:error] = "Ta strona nie istnieje!"
    redirect_to '/'
  end
end
