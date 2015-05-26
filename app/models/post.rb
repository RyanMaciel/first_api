class Post < ActiveRecord::Base
	belongs_to :user
	validates :latitude, presence: true 
	validates :longitude, presence: true
	validates :image_url, presence: true
	before_save :numerical_coords
	
	def numerical_coords
		latitude = latitude.to_f
		longitude = longitude.to_f
	end
end
