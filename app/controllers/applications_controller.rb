class ApplicationsController < ApplicationController
    before_action :load_application, only: :create
    load_and_authorize_resource

    # GET /applications
    # GET /applications.json
    def index
        status = params[:status].downcase.to_sym if params[:status].present?
        if [:all, :closed].include? status
            @status = status
        else
            @status = Application::STATUS_IDS.key?(status) ? status : :open
        end
        respond_to do |format|
            format.html do
                @applications = @applications.recent
                case @status
                when :all
                when :closed
                    @applications = @applications.only_closed
                else
                    @applications = @applications.only_status(@status)
                end
                @applications = @applications.page(params[:page]).per(30)
            end
            format.json { }
        end
    end

    # GET /applications/1
    # GET /applications/1.json
    def show
        if @application.verified_character
            @character = Character.where(name: @application.character_name).first
        end

        if can? :read, Comment, @application
            @commentable = @application
            @comments = @commentable.comments.recent.page(params[:page]).per(15)
            @comment = Comment.new
        end
    end

    # GET /applications/new
    def new
        if not view_context.can_apply?
            flash[:error] = 'You are not allowed to create new applications. If you have already applied to the guild, you can find a link to your application on your profile page.'
            redirect_to root_path
        end

        @character = current_user.character if current_user.confirmed_character?
    end

    # GET /applications/1/edit
    def edit
        @character = @application.user.character if @application.user.confirmed_character?
    end

    # POST /applications
    # POST /applications.json
    def create
        if not view_context.can_apply?
            flash[:error] = 'You are not allowed to create new applications. If you have already applied to the guild, you can find a link to your application on your profile page.'
            redirect_to root_path
        end

        respond_to do |format|
            if @application.save
                format.html { redirect_to @application, notice: 'Application was successfully created.' }
                format.json { render action: 'show', status: :created, location: @application }
            else
                format.html { render action: 'new' }
                format.json { render json: @application.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /applications/1
    # PATCH/PUT /applications/1.json
    def update
        if @application.user.confirmed_character?
            c = @application.user.character
            @application.character_name = c.name
            @application.character_realm = c.realm
            @application.character_guild = c.guild
            @application.verified_character = true
        end
        respond_to do |format|
            if @application.update(application_params)
                format.html { redirect_to @application, notice: 'Application was successfully updated.' }
                format.json { head :no_content }
            else
                format.html { render action: 'edit' }
                format.json { render json: @application.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /applications/1
    # DELETE /applications/1.json
    def destroy
        @application.destroy
        respond_to do |format|
            format.html { redirect_to applications_url, notice: 'Application was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    # PATCH /applications/1/open
    # PATCH /applications/1/open.json
    def open
        authorize! :open, @application
        @application.open
        respond_to do |format|
            if @application.save
                format.html { redirect_to @application, notice: 'Application was successfully opened.' }
                format.json { head :no_content }
            else
                format.html { redirect_to @application, flash: { error: 'Unable to accept opened.' } }
                format.json { render json: 'Unable to open application', status: :unprocessable_entity }
            end
        end
    end

    # PATCH /applications/1/accept
    # PATCH /applications/1/accept.json
    def accept
        authorize! :accept, @application
        @application.accept
        respond_to do |format|
            if @application.save
                format.html { redirect_to @application, notice: 'Application was successfully accepted.' }
                format.json { head :no_content }
            else
                format.html { redirect_to @application, flash: { error: 'Unable to accept application.' } }
                format.json { render json: 'Unable to accept application', status: :unprocessable_entity }
            end
        end
    end

    # PATCH /applications/1/decline
    # PATCH /applications/1/decline.json
    def decline
        authorize! :decline, @application
        @application.decline
        respond_to do |format|
            if @application.save
                format.html { redirect_to @application, notice: 'Application was successfully declined.' }
                format.json { head :no_content }
            else
                format.html { redirect_to @application, flash: { error: 'Unable to decline application.' } }
                format.json { render json: 'Unable to decline application', status: :unprocessable_entity }
            end
        end
    end

    private
        # Only allow a trusted parameter "white list" through.
        def application_params
            params.require(:application).permit(:content, :character_name, :character_realm, :character_guild)
        end

        def load_application
            @application = current_user.build_application(application_params)
            @application.status = Application::STATUS_IDS[:open]
            if current_user.confirmed_character?
                @application.character_name = current_user.character.name
                @application.character_realm = WoW.realm
                @application.character_guild = WoW.guild
                @application.verified_character = true
            else
                @application.verified_character = false
            end
        end
end
