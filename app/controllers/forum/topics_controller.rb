class Forum::TopicsController < ForumController
    layout 'forum/topics'

    load_resource :category, class: 'Forum::Category', only: [:index, :new, :create]
    load_resource :forum, class: 'Forum::Forum', only: [:index, :new, :create]
    before_action :load_topic, only: :create
    load_and_authorize_resource through: :forum, only: [:index, :new, :create]
    load_and_authorize_resource except: [:index, :new, :create]
    before_action :load_additional, only: [:show, :edit, :destroy]

    # GET /forum/topics
    # GET /forum/topics.json
    def index
    end

    # GET /forum/topics/1
    # GET /forum/topics/1.json
    def show
        @posts = @topic.posts.page(params[:page]).per(25)
        @post = @topic.posts.build
        @post_form_url = forum_category_forum_topic_posts_path(@category, @forum, @topic)
    end

    # GET /forum/topics/new
    def new
        @topic.posts.build
        @topic_form_url = forum_category_forum_topics_path(@category, @forum)
    end

    # GET /forum/topics/1/edit
    def edit
    end

    # POST /forum/topics
    # POST /forum/topics.json
    def create
        @topic_form_url = forum_category_forum_topics_path(@category, @forum)
        respond_to do |format|
            if @topic.save
                format.html { redirect_to @topic, notice: 'Topic was successfully created.' }
                format.json { render action: 'show', status: :created, location: @topic }
            else
                format.html { render action: 'new' }
                format.json { render json: @topic.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /forum/topics/1
    # PATCH/PUT /forum/topics/1.json
    def update
        respond_to do |format|
            if @topic.update(topic_params)
                format.html { redirect_to @topic, notice: 'Topic was successfully updated.' }
                format.json { head :no_content }
            else
                format.html { render action: 'edit' }
                format.json { render json: @topic.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /forum/topics/1
    # DELETE /forum/topics/1.json
    def destroy
        @topic.destroy
        respond_to do |format|
            format.html { redirect_to @forum, notice: 'Topic was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    # PATCH /forum/topics/1/lock
    # PATCH /forum/topics/1/lock.json
    def lock
        authorize! :lock, @topic
        @topic.lock
        respond_to do |format|
            if @topic.save
                format.html { redirect_to @topic, notice: 'Topic was successfully locked.' }
                format.json { head :no_content }
            else
                format.html { redirect_to @topic, flash: { error: 'Unable to lock topic.' } }
                format.json { render json: 'Unable to lock topic.', status: :unprocessable_entity }
            end
        end
    end

    # PATCH /forum/topics/1/pin
    # PATCH /forum/topics/1/pin.json
    def lock
        authorize! :pin, @topic
        @topic.pin
        respond_to do |format|
            if @topic.save
                format.html { redirect_to @topic, notice: 'Topic was successfully pinned.' }
                format.json { head :no_content }
            else
                format.html { redirect_to @topic, flash: { error: 'Unable to pin topic.' } }
                format.json { render json: 'Unable to pin topic.', status: :unprocessable_entity }
            end
        end
    end

    private
        # Only allow a trusted parameter "white list" through.
        def topic_new_params
            params.require(:forum_topic).permit(:title, :locked, :pinned, posts_attributes: [:content])
        end

        def topic_params
            params.require(:forum_topic).permit(:title, :locked, :pinned)
        end

        def load_topic
            @topic = @forum.topics.build(topic_new_params)
            @topic.user = current_user
            @topic.unlock if cannot? :lock, @topic
            @topic.unpin if cannot? :pin, @topic
        end

        def load_additional
            @forum = @topic.forum
            @category = @forum.category
        end
end
