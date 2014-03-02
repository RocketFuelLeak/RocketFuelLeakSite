class CharactersController < ApplicationController
    before_action :load_from_armory, only: :post_connect
    load_and_authorize_resource

    # GET /characters
    # GET /characters.json
    def index
        authorize! :manage, Character

        @characters = @characters.includes(:user).ordered

        respond_to do |format|
            format.html { @characters = @characters.page(params[:page]).per(50) }
            format.json { }
        end
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

    # GET /characters/connect
    def connect
        if current_user.character
            flash[:error] = 'You have already connected a character, please go to your profile page to confirm it.'
            redirect_to root_path
        end
        @character = Character.new
    end

    # GET /characters/1/confirm
    def confirm
        if current_user.character
            if current_user.character.confirmed
                flash[:error] = 'You have already confirmed your character.'
                redirect_to root_path
            end
        else
            flash[:error] = 'You need to connect a character to your account before you can confirm it.'
            redirect_to root_path
        end
    end

    # POST /characters
    # POST /characters.json
    def create
        respond_to do |format|
            if @character.save
                format.html { redirect_to @character, notice: 'Character was successfully created.' }
                format.json { render action: 'show', status: :created, location: @character }
            else
                format.html { render action: 'new' }
                format.json { render json: @character.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /characters/1
    # PATCH/PUT /characters/1.json
    def update
        respond_to do |format|
            if @character.update(character_params)
                format.html { redirect_to @character, notice: 'Character was successfully updated.' }
                format.json { head :no_content }
            else
                format.html { render action: 'edit' }
                format.json { render json: @character.errors, status: :unprocessable_entity }
            end
        end
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
    def post_connect
        if current_user.character
            flash[:error] = 'You have already connected a character, please go to your profile page to confirm it.'
            redirect_to root_path
        end
        respond_to do |format|
            if @character.save
                flash[:success] = 'Character was successfully connected.'
                format.html { redirect_to confirm_character_path(@character) }
                format.json { render action: 'show', status: :connected, location: @character }
            else
                format.html { render action: 'connect' }
                format.json { render json: @character.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH /characters/1/confirm
    # PATCH /characters/1/confirm.json
    def patch_confirm
        if current_user.character
            if current_user.character.confirmed
                flash[:error] = 'You have already confirmed your character.'
                redirect_to root_path
                return
            end
        else
            flash[:error] = 'You need to connect a character to your account before you can confirm it.'
            redirect_to root_path
            return
        end

        @character.confirm_character

        respond_to do |format|
            if @character.save
                flash[:success] = "Successfully confirmed character!"
                format.html { redirect_to @character.user }
                format.json { head :no_content }
            else
                format.html { render action: 'confirm' }
                format.json { render json: @character.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH /characters/1/toggle_confirmed
    # PATCH /characters/1/toggle_confirmed.json
    def toggle_confirmed
        authorize! :manage, @character
        @character.confirmed = !@character.confirmed
        respond_to do |format|
            if @character.save
                format.html { redirect_to @character, notice: 'Character was successfully updated.' }
                format.json { head :no_content }
            else
                format.html { render action: 'edit' }
                format.json { render json: @character.errors, status: :unprocessable_entity }
            end
        end
    end

    private
        # Only allow a trusted parameter "white list" through.
        def character_params
            params.require(:character).permit(:name, :realm, :confirmed)
        end

        def character_connect_params
            params.require(:character).permit(:name, :realm)
        end

        def load_from_armory
            @character = Character.from_armory(character_connect_params[:name], character_connect_params[:realm])
            @character.user = current_user
        end
end
