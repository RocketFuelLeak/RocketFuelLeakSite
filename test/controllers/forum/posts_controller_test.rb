require 'test_helper'

class Forum::PostsControllerTest < ActionController::TestCase
  setup do
    @forum_post = forum_posts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:forum_posts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create forum_post" do
    assert_difference('Forum::Post.count') do
      post :create, forum_post: { content: @forum_post.content, forum_topic_id: @forum_post.forum_topic_id, user_id: @forum_post.user_id }
    end

    assert_redirected_to forum_post_path(assigns(:forum_post))
  end

  test "should show forum_post" do
    get :show, id: @forum_post
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @forum_post
    assert_response :success
  end

  test "should update forum_post" do
    patch :update, id: @forum_post, forum_post: { content: @forum_post.content, forum_topic_id: @forum_post.forum_topic_id, user_id: @forum_post.user_id }
    assert_redirected_to forum_post_path(assigns(:forum_post))
  end

  test "should destroy forum_post" do
    assert_difference('Forum::Post.count', -1) do
      delete :destroy, id: @forum_post
    end

    assert_redirected_to forum_posts_path
  end
end
