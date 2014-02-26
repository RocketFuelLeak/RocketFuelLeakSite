class CommentsController < ApplicationController
    load_resource :post, instance_name: :commentable, class: 'Post'
    before_filter :auth_commentable
    before_action :create_comment, only: :create
    load_and_authorize_resource :comment, through: :commentable

    # GET /comments
    # GET /comments.json
    def index
        @comments = @comments.recent.page(params[:page]).per(50)
    end

    # GET /comments/1
    # GET /comments/1.json
    def show
    end

    # GET /comments/new
    def new
    end

    # GET /comments/1/edit
    def edit
    end

    # POST /comments
    # POST /comments.json
    def create
        respond_to do |format|
            if @comment.save
                format.html { redirect_to @commentable, notice: 'Comment was successfully created.' }
                format.json { render action: 'show', status: :created, location: @comment }
            else
                format.html { render action: 'new' }
                format.json { render json: @comment.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /comments/1
    # PATCH/PUT /comments/1.json
    def update
        respond_to do |format|
            if @comment.update(comment_params)
                format.html { redirect_to @commentable, notice: 'Comment was successfully updated.' }
                format.json { head :no_content }
            else
                format.html { render action: 'edit' }
                format.json { render json: @comment.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /comments/1
    # DELETE /comments/1.json
    def destroy
        @comment.destroy
        respond_to do |format|
            format.html { redirect_to @commentable, notice: 'Comment was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private
        def auth_commentable
            authorize! :read, @commentable       
        end

        # Only allow a trusted parameter "white list" through.
        def comment_params
            params.require(:comment).permit(:content)
        end

        def create_comment
            @comment = @commentable.comments.new(comment_params)
            @comment.user = current_user
        end
end
