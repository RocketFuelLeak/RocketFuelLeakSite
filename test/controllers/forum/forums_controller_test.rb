require 'test_helper'

class Forum::ForumsControllerTest < ActionController::TestCase
  setup do
    @forum_forum = forum_forums(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:forum_forums)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create forum_forum" do
    assert_difference('Forum::Forum.count') do
      post :create, forum_forum: { forum/category_id: @forum_forum.forum/category_id, name: @forum_forum.name, order: @forum_forum.order, read_access: @forum_forum.read_access, write_access: @forum_forum.write_access }
    end

    assert_redirected_to forum_forum_path(assigns(:forum_forum))
  end

  test "should show forum_forum" do
    get :show, id: @forum_forum
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @forum_forum
    assert_response :success
  end

  test "should update forum_forum" do
    patch :update, id: @forum_forum, forum_forum: { forum/category_id: @forum_forum.forum/category_id, name: @forum_forum.name, order: @forum_forum.order, read_access: @forum_forum.read_access, write_access: @forum_forum.write_access }
    assert_redirected_to forum_forum_path(assigns(:forum_forum))
  end

  test "should destroy forum_forum" do
    assert_difference('Forum::Forum.count', -1) do
      delete :destroy, id: @forum_forum
    end

    assert_redirected_to forum_forums_path
  end
end
