class Forum::ForumsController < ForumController
    layout 'forum/forums'

    load_resource :category, class: 'Forum::Category', only: [:index, :new, :create]
    before_action :load_forum, only: :create
    load_and_authorize_resource through: :category, only: [:index, :new, :create]
    load_and_authorize_resource except: [:index, :new, :create]
    before_action :load_category, only: [:show, :edit]

    # GET /forums
    # GET /forums.json
    def index
    end

    # GET /forums/1
    # GET /forums/1.json
    def show
        @topics = @forum.topics.recent.page(params[:page]).per(30)
    end

    # GET /forums/new
    def new
        @forum_form_url = forum_category_forums_path(@category)
    end

    # GET /forums/1/edit
    def edit
    end

    # POST /forums
    # POST /forums.json
    def create
        @forum_form_url = forum_category_forums_path(@category)
        respond_to do |format|
            if @forum.save
                format.html { redirect_to @forum, notice: 'Forum was successfully created.' }
                format.json { render action: 'show', status: :created, location: @forum_forum }
            else
                format.html { render action: 'new' }
                format.json { render json: @forum.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /forums/1
    # PATCH/PUT /forums/1.json
    def update
        respond_to do |format|
            if @forum.update(forum_params)
                format.html { redirect_to @forum, notice: 'Forum was successfully updated.' }
                format.json { head :no_content }
            else
                format.html { render action: 'edit' }
                format.json { render json: @forum.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /forums/1
    # DELETE /forums/1.json
    def destroy
        @forum.destroy
        respond_to do |format|
            format.html { redirect_to @forum.category, notice: 'Forum was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private
        # Only allow a trusted parameter "white list" through.
        def forum_params
            params.require(:forum_forum).permit(:name, :description, :order, :read_access, :write_access)
        end

        def load_forum
            #@forum = Forum::Forum.new(forum_params)
            @forum = @category.forums.build(forum_params)
        end

        def load_category
            @category = @forum.category
        end
end
