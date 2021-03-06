class AnnoncesController < ApplicationController

before_action :set_annonce, only: [ :show, :edit, :update]
before_action :authenticate_user!, except: [:show]
before_action :require_same_user, only: [:edit, :update]

def index
	@annonces = current_user.annonces
end

def new
	@annonces = current_user.annonces.build
end

def create
	@annonces = current_user.annonces.build
	if @annonces.save
			if params[:image]
				params[:image].each do |i|
					@annonce.photos.create(image: i)
			end
	end
		@photos = @annonces.photos
		redirect_to new_annonce_path(@annonce), notice: "Votre annonce a été ajoutée avec succès"
	end
end


 
 def show
 	@annonce = Annonce.find(params[:id])
 	@photos = @annonce.photos

 end

 def edit
 	@annonce = Annonce.find(params[:id])
 	if params[:image]
				params[:image].each do |i|
					@annonce.photos.create(image: i)
	end
		@photos = @annonce.photos
		redirect_to edit_annonce_path(@annonce), notice: "Modification enregistrée"
	end
 end




def update
	if @annonces.update(annonce_params)
		redirect_to @annonce, notice: "Modification enregistrée..." 
	else 
		render :edit
	end
end


private
	def set_annonce
		@annonce = Annonce.find(params[:id])
	end

	def annonces_params
		params.require(:annonces).permit(:name, :description, :address)
	end

	def require_same_user
		if current_user.id != @annonce.user_id
			flash[:danger] = "Vous n'avez pas le droit de modifier cette page"
			redirect_to root_path
		
	end
end
end


