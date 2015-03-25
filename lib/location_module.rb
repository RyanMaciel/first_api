module LocationModule
  include Math

	#Takes a set of coords and a post and calculates their distance based on the haversine formula
    def distance(latitude, longitude, post)
      return spherical_distance([latitude, longitude], [post.latitude, post.longitude])
    end

    private
    	def spherical_distance(start_coords, end_coords)
      	# rough radius of the Earth, in kilometers
      	radius = 6371
      	lat1, long1 = deg2rad *start_coords
      	lat2, long2 = deg2rad *end_coords
      	2 * radius * asin(sqrt(sin((lat2-lat1)/2)**2 + cos(lat1) * cos(lat2) * sin((long2 - long1)/2)**2))
    	end
 
    	def deg2rad(lat, long)
      	[lat * PI / 180, long * PI / 180]
    	end
end