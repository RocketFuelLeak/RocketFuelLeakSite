class Forum::PostsController < ForumController
    layout 'forum/posts'

    load_resource :category, class: 'Forum::Category', only: [:index, :new, :create]
    load_resource :forum, class: 'Forum::Forum', only: [:index, :new, :create]
    load_resource :topic, class: 'Forum::Topic', only: [:index, :new, :create]
    before_action :load_post, only: :create
    load_and_authorize_resource through: :topic, only: [:index, :new, :create]
    load_and_authorize_resource except: [:index, :new, :create]
    before_action :load_additional, only: [:show, :new, :edit]

    # GET /forum/posts
    # GET /forum/posts.json
    def index
        @post = @topic.posts.build
        @post_form_url = forum_category_forum_topic_posts_path(@category, @forum, @topic)
    end

    # GET /forum/posts/1
    # GET /forum/posts/1.json
    def show
    end

    # GET /forum/posts/new
    def new
        @post_form_url = forum_category_forum_topic_posts_path(@category, @forum, @topic)
    end

    # GET /forum/posts/1/edit
    def edit
    end

    # POST /forum/posts
    # POST /forum/posts.json
    def create
        respond_to do |format|
            if @post.save
                format.html { redirect_to @post.topic, notice: 'Post was successfully created.' }
                format.json { render action: 'show', status: :created, location: @post }
            else
                format.html { render action: 'new' }
                format.json { render json: @post.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /forum/posts/1
    # PATCH/PUT /forum/posts/1.json
    def update
        respond_to do |format|
            if @post.update(post_params)
                format.html { redirect_to @post.topic, notice: 'Post was successfully updated.' }
                format.json { head :no_content }
            else
                format.html { render action: 'edit' }
                format.json { render json: @post.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /forum/posts/1
    # DELETE /forum/posts/1.json
    def destroy
        @post.destroy
        respond_to do |format|
            format.html { redirect_to forum_posts_url, notice: 'Post was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private
        # Only allow a trusted parameter "white list" through.
        def post_params
            params.require(:forum_post).permit(:content)
        end

        def load_post
            @post = @topic.posts.build(post_params)
            @post.user = current_user
        end

        def load_additional
            @topic = @post.topic
            @forum = @topic.forum
            @category = @forum.category
        end
end
