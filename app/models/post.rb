class Post < ActiveRecord::Base
	validates :latitude, presence: true 
	validates :longitude, presence: true
	validates :image_url, presence: true
	before_save :numerical_coords
	belongs_to :user
	def numerical_coords
		latitude = latitude.to_f
		longitude = longitude.to_f
	end
end
