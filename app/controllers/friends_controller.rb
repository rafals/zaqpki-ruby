class FriendsController < ApplicationController
  before_filter :login_required
  def invite
    if recipient = Account.find_by_email(params[:email])
      if Invitation.find_by_from_id_and_to_id current_user.id, recipient.id
        flash[:error] = "Zaproszenie zostalo juz wyslane do uzytkownika " + recipient.name
      else
        Invitation.create :from_id => current_user.id, :to_id => recipient.id
        flash[:notice] = "Zaproszenie zostalo wyslane"
      end
    else
      flash[:error] = "Uzytkownik nie istnieje"
    end
    redirect_to "/"
  end
  
  def confirm_invitation
    if invitation = Invitation.find(params[:id])
      current_user.connect invitation.from
      invitation.destroy
      flash[:notice] =  "Przyjeto zaproszenie"
    else
      flash[:error] = "Nie ma takiego zaproszenia"
    end
    redirect_to "/"
  end
  
  def reject_invitation
    if invitation = Invitation.find(params[:id])
      if (invitation.from == current_user and flash[:notice] =  "Zaproszenie wycofano") or 
         (invitation.to == current_user and flash[:notice] =  "Zaproszenie odrzucono")
        invitation.destroy
      else
        flash[:error] =  "Nie masz dostepu"
      end
    else
      flash[:error] = "Nie ma takiego zaproszenia"
    end
    redirect_to "/"
  end
end
