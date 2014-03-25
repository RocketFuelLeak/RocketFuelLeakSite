class Forum::PostsController < ForumController
    before_action :load_forum_post, only: :create
    load_and_authorize_resource

    # GET /forum/posts
    # GET /forum/posts.json
    def index
    end

    # GET /forum/posts/1
    # GET /forum/posts/1.json
    def show
    end

    # GET /forum/posts/new
    def new
    end

    # GET /forum/posts/1/edit
    def edit
    end

    # POST /forum/posts
    # POST /forum/posts.json
    def create
        respond_to do |format|
            if @forum_post.save
                format.html { redirect_to @forum_post, notice: 'Post was successfully created.' }
                format.json { render action: 'show', status: :created, location: @forum_post }
            else
                format.html { render action: 'new' }
                format.json { render json: @forum_post.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /forum/posts/1
    # PATCH/PUT /forum/posts/1.json
    def update
        respond_to do |format|
            if @forum_post.update(forum_post_params)
                format.html { redirect_to @forum_post, notice: 'Post was successfully updated.' }
                format.json { head :no_content }
            else
                format.html { render action: 'edit' }
                format.json { render json: @forum_post.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /forum/posts/1
    # DELETE /forum/posts/1.json
    def destroy
        @forum_post.destroy
        respond_to do |format|
            format.html { redirect_to forum_posts_url, notice: 'Post was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private
        # Only allow a trusted parameter "white list" through.
        def forum_post_params
            params.require(:forum_post).permit(:content, :forum_topic_id, :user_id)
        end

        def load_forum_post
            @forum_post = Forum::Post.new(forum_post_params)
        end
end
