class UsersController < ApplicationController
    before_action :load_user, only: :create
    load_and_authorize_resource

    # GET /users
    # GET /users.json
    def index
        authorize! :manage, @users

        @users = @users.includes(:character)

        respond_to do |format|
            format.html { @users = @users.page(params[:page]).per(50) }
            format.json { }
        end
    end

    # GET /users/1
    # GET /users/1.json
    def show
        if @user.application.present?
            @application = @user.application
        end
    end

    # GET /users/new
    def new
    end

    # GET /users/1/edit
    def edit
    end

    # POST /users
    # POST /users.json
    def create
        respond_to do |format|
            if @user.save
                format.html { redirect_to @user, notice: 'User was successfully created.' }
                format.json { render action: 'show', status: :created, location: @user }
            else
                format.html { render action: 'new' }
                format.json { render json: @user.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /users/1
    # PATCH/PUT /users/1.json
    def update
        respond_to do |format|
            if @user.update(user_params)
                format.html { redirect_to @user, notice: 'User was successfully updated.' }
                format.json { head :no_content }
            else
                format.html { render action: 'edit' }
                format.json { render json: @user.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /users/1
    # DELETE /users/1.json
    def destroy
        @user.destroy
        respond_to do |format|
            format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    # PATCH /users/1/toggle/member
    # PATCH /users/1/toggle/member
    def toggle_role
        do_toggle_role params[:role]
    end

    # PATCH /users/1/toggle_member
    # PATCH /users/1/toggle_member.json
    def toggle_member
        do_toggle_role :member
    end

    # PATCH /users/1/toggle_officer
    # PATCH /users/1/toggle_officer.json
    def toggle_officer
        do_toggle_role :officer
    end

    # PATCH /users/1/toggle_admin
    # PATCH /users/1/toggle_admin.json
    def toggle_admin
        do_toggle_role :admin
    end

    private
        # Only allow a trusted parameter "white list" through.
        def user_params
            params.require(:user).permit(:username, :email, :password)
        end

        def load_user
            @user = User.new(user_params)
        end

        def do_toggle_role(role)
            authorize! :manage, @user
            if @user.has_role? role
                @user.remove_role role
            else
                @user.add_role role
            end
            
            respond_to do |format|
                format.html { redirect_to :back, notice: 'User role successfully edited.' }
                format.json { head :no_content }
            end
        end
end
