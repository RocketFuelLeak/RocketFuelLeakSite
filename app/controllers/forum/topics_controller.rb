class Forum::TopicsController < ForumController
    layout 'forum/topics'

    before_action :load_topic, only: :create
    load_and_authorize_resource
    before_action :load_additional, only: [:show, :new, :edit]

    # GET /forum/topics
    # GET /forum/topics.json
    def index
    end

    # GET /forum/topics/1
    # GET /forum/topics/1.json
    def show
        @posts = @topic.posts.page(params[:page]).per(25)
    end

    # GET /forum/topics/new
    def new
    end

    # GET /forum/topics/1/edit
    def edit
    end

    # POST /forum/topics
    # POST /forum/topics.json
    def create
        respond_to do |format|
            if @forum_topic.save
                format.html { redirect_to @forum_topic, notice: 'Topic was successfully created.' }
                format.json { render action: 'show', status: :created, location: @forum_topic }
            else
                format.html { render action: 'new' }
                format.json { render json: @forum_topic.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /forum/topics/1
    # PATCH/PUT /forum/topics/1.json
    def update
        respond_to do |format|
            if @forum_topic.update(forum_topic_params)
                format.html { redirect_to @forum_topic, notice: 'Topic was successfully updated.' }
                format.json { head :no_content }
            else
                format.html { render action: 'edit' }
                format.json { render json: @forum_topic.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /forum/topics/1
    # DELETE /forum/topics/1.json
    def destroy
        @forum_topic.destroy
        respond_to do |format|
            format.html { redirect_to forum_topics_url, notice: 'Topic was successfully destroyed.' }
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
        def topic_params
            params.require(:forum_topic).permit(:title, :locked, :pinned, :forum_forum_id)
        end

        def load_topic
            @topic = Forum::Topic.new(topic_params)
            @topic.user = current_user
        end

        def load_additional
            @forum = @topic.forum
            @category = @forum.category
        end
end
