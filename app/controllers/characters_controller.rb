class CharactersController < ApplicationController
    before_action :load_from_armory, only: :connect
    load_and_authorize_resource

    # GET /characters
    # GET /characters.json
    def index
    end

    # GET /characters/1
    # GET /characters/1.json
    def show
    end

    # GET /characters/new
    def new
    end

    # GET /characters/1/edit
    def edit
    end

    # GET /characters/connection
    def connection
        redirect_to current_user.character if current_user.character
        @character = Character.new
    end

    # GET /characters/confirmation
    def confirmation
        redirect_to connection_character_path unless current_user.character
        redirect_to current_user.character if current_user.character and current_user.character.confirmed
    end

    # POST /characters
    # POST /characters.json
    def create
        
    end

    # PATCH/PUT /characters/1
    # PATCH/PUT /characters/1.json
    def update
        
    end

    # DELETE /characters/1
    # DELETE /characters/1.json
    def destroy
        @character.destroy
        respond_to do |format|
            format.html { redirect_to characters_url, notice: 'Character was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    # POST /characters/connect
    # POST /characters/connect.json
    def connect
        respond_to do |format|
            if @character.save
                flash[:success] = 'Character was successfully connected.'
                format.html { redirect_to confirmation_character_path(@character) }
                format.json { render action: 'show', status: :connected, location: @character }
            else
                format.html { render action: 'connection' }
                format.json { render json: @character.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH /characters/1/confirm
    # PATCH /characters/1/confirm.json
    def confirm
        @character.confirm_character

        respond_to do |format|
            if @character.save
                flash[:success] = "Successfully confirmed character!"
                format.html { redirect_to @character.user }
                format.json { head :no_content }
            else
                format.html { render action: 'confirmation' }
                format.json { render json: @character.errors, status: :unprocessable_entity }
            end
        end
    end

    private
        # Only allow a trusted parameter "white list" through.
        def character_params
            params.require(:character).permit(:name, :realm, :avatar, :guild)
        end

        def character_connect_params
            params.require(:character).permit(:name)
        end

        def load_from_armory
            @character = Character.from_armory(character_connect_params[:name])
            @character.user = current_user
        end
end
