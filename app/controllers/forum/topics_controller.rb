class Forum::TopicsController < ForumController
    before_action :load_forum_topic, only: :create
    load_and_authorize_resource

    # GET /forum/topics
    # GET /forum/topics.json
    def index
    end

    # GET /forum/topics/1
    # GET /forum/topics/1.json
    def show
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

    private
        # Only allow a trusted parameter "white list" through.
        def forum_topic_params
            params.require(:forum_topic).permit(:title, :locked, :pinned, :forum_forum_id, :user_id)
        end

        def load_forum_topic
            @forum_topic = Forum::Topic.new(forum_topic_params)
        end
end
