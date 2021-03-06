require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
  	@user = User.new(username: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar");
  end

  test "user should be valid" do
  	assert @user.valid?
	end

	#test username
  test "username should be present" do
  	@user.username = "     "
  	assert_not @user.valid?
  end

  test "username should not be too long" do
  	@user.username = "a" * 41
  	assert_not @user.valid?
  end

  #test emails
  test "email should be present" do
  	@user.email = "    "
  	assert_not @user.valid?
  end

  #make sure the email is less than 256 characters.
  test "email should not be too long" do
  	@user.email = "a" * 244 + "@example.com"
  	assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

	test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  #test passwords
  test "password should not be too short" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end 

  #test api_key
  test "api_key_should_validate" do
    @user.generate_api_key
    assert !!@user.authenticate_api_key(@user.api_key)
  end

  test "bad_api_key_should_be_invalid" do 
    assert_not !!@user.authenticate_api_key("randomkey")
  end
end
