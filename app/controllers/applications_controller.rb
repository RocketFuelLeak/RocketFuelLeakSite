class ApplicationsController < ApplicationController
    before_action :load_application, only: :create
    load_and_authorize_resource

    # GET /applications
    # GET /applications.json
    def index
    end

    # GET /applications/1
    # GET /applications/1.json
    def show
    end

    # GET /applications/new
    def new
    end

    # GET /applications/1/edit
    def edit
    end

    # POST /applications
    # POST /applications.json
    def create
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

    private
        # Only allow a trusted parameter "white list" through.
        def application_params
            params.require(:application).permit(:content, :character_name, :character_realm, :character_guild, :status, :user_id)
        end

        def load_application
            @application = Application.new(application_params)
        end
end
