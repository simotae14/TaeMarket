class ContentsController < ApplicationController
  before_action :set_content, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :check_user, only: [:edit, :update, :destroy]
  
  def index
    @contents = Content.all.order('created_at DESC').paginate(:page => params[:page], :per_page => 12)
  end

  def show
  end

  def new
    @content = current_user.contents.build
  end

  def edit1
  end

  

  private
    def set_content
      @content = Content.friendly.find(params[:id])
    end

    def content_params
      params.require(:content).permit(:titolo, :descrizione, :price, :cover, :allegato)
    end
    
    def check_user
      if current_user != @content.user
        redirect_to root_path, alert: "Scusa ma non hai accesso a questa pagina"
      end
    end
end
