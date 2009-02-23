class IntroController < ApplicationController
  def index
  end

  def error404
    flash[:error] = "Ta strona nie istnieje!"
    redirect_to :action => 'index'
  end
end
