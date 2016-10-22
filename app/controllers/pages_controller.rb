class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard]
  
  def home
  end
  
  def about
  end
  
  def dashboard
    @contents = current_user.contents
    #vendite
    @sales = Sale.where(email_venditore: current_user.email)
    #acquisti
    @purchased = Sale.where(email_acquirente: current_user.email)
  end
end
