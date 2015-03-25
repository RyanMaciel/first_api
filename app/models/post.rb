class Post < ActiveRecord::Base
	validates :latitude, presence: true 
	validates :longitude, presence: true
	validates :image_url, presence: true

	def numericalCoords
		latitude = latitude.to_f
		longitude = longitude.to_f
	end
end
