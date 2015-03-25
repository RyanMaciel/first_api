class Post < ActiveRecord::Base
	validates :latitude, presence: true 
	validates :longitude, presence: true
	validates :image_url, presence: true
end
