require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { name:  "",
                                    email: "foo@invalid",
                                    password:              "foo",
                                    password_confirmation: "bar" }
    assert_template 'users/edit'
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), user: { name:  name,
                                    email: email,
                                    password:              "",
                                    password_confirmation: "" }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end

  test "not login edit" do
    name  = @user.name
    email = @user.email
    patch user_path(@user), user: { name:  "Foo Bar",
                                    email: "foo@bar.com",
                                    password:              "",
                                    password_confirmation: "" }
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end

  test "other user edit" do
    log_in_as(@user)
    name  = "other"
    email = "other@bar.com"
    @other = User.create(name: name, email: email, password: "hogehoge", password_confirmation: "hogehoge")
    patch user_path(@other), user: { name: "Foo Bar",
                                    email: "foo@bar.com",
                                    password:              "",
                                    password_confirmation: "" }
    @other.reload
    assert_equal name,  @other.name
    assert_equal email, @other.email
  end
end
