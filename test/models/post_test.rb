require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
 # end

  test "should have presence validators" do
  	post = Post.new
  	assert_not post.valid?
  	assert_equal [:latitude, :longitude, :image_url], post.errors.keys
  end

end
