class User < ActiveRecord::Base
	has_many :posts

	before_save {self.email = email.downcase}

	#create the api key
	before_create do |user|
  	user.api_key = user.generate_api_key
	end

	validates :username, presence: true, length: {maximum:40}
	validates :email, presence: true, length: {maximum: 255}, format: {with:/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i}, uniqueness: {case_sensitive: false}
	validates :password, presence: true, length: {minimum: 6};
	has_secure_password

	def generate_api_key
 		loop do
 	  	token = SecureRandom.base64.tr('+/=', 'Qrt')
 	 		break token unless User.exists?(api_key: token)
 	 	end
 	end
end
