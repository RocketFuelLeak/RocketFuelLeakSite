class Forum::CategoriesController < ForumController
    layout 'forum/categories'

    before_action :load_category, only: :create
    load_and_authorize_resource

    # GET /forum/categories
    # GET /forum/categories.json
    def index
        @categories = @categories.includes(:forums).ordered
    end

    # GET /forum/categories/1
    # GET /forum/categories/1.json
    def show
    end

    # GET /forum/categories/new
    def new
        @category_form_url = forum_categories_path
    end

    # GET /forum/categories/1/edit
    def edit
    end

    # POST /forum/categories
    # POST /forum/categories.json
    def create
        @category_form_url = forum_categories_path
        respond_to do |format|
            if @category.save
                format.html { redirect_to @category, notice: 'Category was successfully created.' }
                format.json { render action: 'show', status: :created, location: @category }
            else
                format.html { render action: 'new' }
                format.json { render json: @category.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /forum/categories/1
    # PATCH/PUT /forum/categories/1.json
    def update
        respond_to do |format|
            if @category.update(forum_category_params)
                format.html { redirect_to @category, notice: 'Category was successfully updated.' }
                format.json { head :no_content }
            else
                format.html { render action: 'edit' }
                format.json { render json: @category.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /forum/categories/1
    # DELETE /forum/categories/1.json
    def destroy
        @category.destroy
        respond_to do |format|
            format.html { redirect_to forum_categories_url, notice: 'Category was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private
        # Only allow a trusted parameter "white list" through.
        def category_params
            params.require(:forum_category).permit(:name, :order, :access)
        end

        def load_category
            @category = Forum::Category.new(category_params)
        end
end
