module Instagram
	
	# get access token from code
	def self.get_access_token(code)
		options = {client_id: CLIENT_ID,client_secret: CLIENT_SECRET,grant_type: "authorization_code",redirect_uri: "http://localhost:4444/insta_callback",code: code}
		return JSON(RestClient.post "https://api.instagram.com/oauth/access_token",options)
	end
	# get user id from username
	def self.get_userid(username)
		url = "https://api.instagram.com/v1/users/search?q=" + username + "&client_id=" + CLIENT_ID
		return JSON(RestClient.get url)
	end
	# get followers of userid
	def self.get_followers(userid,access_token)
		url = "https://api.instagram.com/v1/users/" + userid + "/followed-by?access_token=" + access_token
		return JSON(RestClient.get url)
	end
	# get recently uploaded media of user
	def self.get_recent_media(userid,access_token)
		url = "https://api.instagram.com/v1/users/" + userid + "/media/recent?access_token=" + access_token
		return JSON(RestClient.get url)
	end
end