class PostsController < ApplicationController
    before_action :load_shared
    before_action :load_post, only: :create
    load_and_authorize_resource

    # GET /posts
    # GET /posts.json
    def index
        @truncate_posts = true

        if can? :read_drafts, Post
            @posts = @posts.recent
        else
            @posts = @posts.recently_published
        end

        respond_to do |format|
            format.html { @posts = @posts.page(params[:page]).per(10) }
            format.json { }
        end
    end

    # GET /posts/1
    # GET /posts/1.json
    def show
        authorize! :read_drafts, @post unless @post.published
        if can? :read, Comment, @post
            @commentable = @post
            @comments = @commentable.comments.recent.page(params[:page]).per(15)
            @comment = Comment.new
        end
    end

    # GET /posts/new
    def new
    end

    # GET /posts/1/edit
    def edit
    end

    # POST /posts
    # POST /posts.json
    def create
        respond_to do |format|
            if @post.save
                format.html { redirect_to @post, notice: 'Post was successfully created.' }
                format.json { render action: 'show', status: :created, location: @post }
            else
                format.html { render action: 'new' }
                format.json { render json: @post.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /posts/1
    # PATCH/PUT /posts/1.json
    def update
        respond_to do |format|
            if @post.update(post_params)
                format.html { redirect_to @post, notice: 'Post was successfully updated.' }
                format.json { head :no_content }
            else
                format.html { render action: 'edit' }
                format.json { render json: @post.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /posts/1
    # DELETE /posts/1.json
    def destroy
        @post.destroy
        respond_to do |format|
            format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    # GET /posts/archive/2014/02
    # GET /posts/archive/2014/02.json
    def archive
        @truncate_posts = true
        year = params[:year]
        month = params[:month]
        @date = Date.parse("#{year}-#{month}-01").strftime('%B, %Y')
        @posts = Post.from_archive(year, month)

        if can? :read_drafts, Post
            @posts = @posts.recent
        else
            @posts = @posts.recently_published
        end

        respond_to do |format|
            format.html { @posts = @posts.page(params[:page]).per(10) }
            format.json { }
        end
    end

    # GET /posts/feed.atom
    def feed
        @posts = Post.recently_published
        @updated = @posts.first.updated_at unless @posts.empty?

        respond_to do |format|
            format.atom { render layout: false }
            # RSS redirects to ATOM
            format.rss { redirect_to feed_posts_path(format: :atom), status: :moved_permanently }
        end
    end

    private
        # Only allow a trusted parameter "white list" through.
        def post_params
            params.require(:post).permit(:title, :content, :published)
        end

        def load_shared
            @posts_by_year = Post.by_year
            @posts_by_month = Post.by_month
        end

        def load_post
            @post = current_user.posts.build(post_params)
        end
end
