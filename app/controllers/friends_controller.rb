class FriendsController < ApplicationController
  def add
    if account = Account.find_by_email(params[:email])
      if current_user.connect account
        flash[:notice] =  "dodano typa do ziomkuff"
      else
        flash[:error] =  "nie dodano typa do ziomkuff"
      end
    else
      flash[:error] = "nie znaleziono typa"
    end
    
    redirect_to "/"
  end
end
