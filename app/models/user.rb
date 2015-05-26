class User < ActiveRecord::Base
	has_many :posts

	before_save {self.email = email.downcase}


	validates :username, presence: true, length: {maximum:40}
	validates :email, presence: true, length: {maximum: 255}, format: {with:/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i}, uniqueness: {case_sensitive: false}
	validates :password, presence: true, length: {minimum: 6};
	has_secure_password

	#return self if the api_key is valid, and false if it is invalid or expired.
	def authenticate_api_key(api_key)
		if api_key == self.api_key 

			if self.api_key_created < Time.now - 60.minutes

				return false
			else
				
				return self
			end
		end
		return false
	end

	def generate_api_key
		token = ""
 		loop do
 	  	token = SecureRandom.base64.tr('+/=', 'Qrt')
 	 		break token unless User.exists?(api_key: token)
 	 	end
 	 	self.api_key = token
 	 	self.api_key_created = Time.now
 	end
end
