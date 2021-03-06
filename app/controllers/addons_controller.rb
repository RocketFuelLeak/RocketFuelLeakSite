class AddonsController < ApplicationController
  before_action :load_addon, only: :create
  load_and_authorize_resource

  # GET /addons
  # GET /addons.json
  def index
    @addons = @addons.alphabetically
  end

  # GET /addons/1
  # GET /addons/1.json
  def show
  end

  # GET /addons/new
  def new
  end

  # GET /addons/1/edit
  def edit
  end

  # POST /addons
  # POST /addons.json
  def create
    respond_to do |format|
      if @addon.save
        format.html { redirect_to addons_path, notice: 'Addon was successfully created.' }
        format.json { render action: 'show', status: :created, location: @addon }
      else
        format.html { render action: 'new' }
        format.json { render json: @addon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /addons/1
  # PATCH/PUT /addons/1.json
  def update
    respond_to do |format|
      if @addon.update(addon_params)
        format.html { redirect_to addons_path, notice: 'Addon was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @addon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /addons/1
  # DELETE /addons/1.json
  def destroy
    @addon.destroy
    respond_to do |format|
      format.html { redirect_to addons_url }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def addon_params
      params.require(:addon).permit(:name, :description, :image, :curse, :curse_download, :wowinterface, :wowinterface_download, :required)
    end

    def load_addon
      @addon = Addon.new(addon_params)
    end
end
