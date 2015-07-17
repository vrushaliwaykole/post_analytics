require "instagram"
class HomeController < ApplicationController
	def analyze
		# If user id provided by user use that
		if(params[:details][:userid].present?)
			userid = params[:details][:userid]
			redirect_to_insta = true
		# If user enters username , get userid 
		elsif(params[:details][:username].present?)
			data = Instagram.get_userid(params[:details][:username])
			if data["meta"]["code"] == 200
				userid = data["data"][0]["id"]
				redirect_to_insta = true
			end
		end
		# authorize app access for user
		if redirect_to_insta
			redirect_to "https://api.instagram.com/oauth/authorize/?client_id=3e9465eb70bb473eaed2066a4ea5633d&redirect_uri=http://localhost:4444/insta_callback&userid=#{userid}&response_type=code"
		else
			redirect_to "/"
		end
	end
	# callback from instagram
	def insta_callback
		if(params[:code])
			# get access token
			access_token = Instagram.get_access_token(params[:code])
			# get followers
			followers = Instagram.get_followers(access_token["user"]["id"],access_token["access_token"])
			dates = []
			followers["data"].each do |rec|
				begin
					# get recent post for each follower
					post = Instagram.get_recent_media(rec["id"],access_token["access_token"])
					dates << Time.at(post["data"][0]["created_time"].to_f)
				rescue
				end
			end
			wday = {}
			time = {}

			dates.each do |date|
				wday[date.wday.to_s] = 0 if wday[date.wday.to_s].nil?
				wday[date.wday.to_s] += 1
				start_hr = date.hour - 1
				end_hr = date.hour + 1
				key = "#{start_hr} - #{end_hr}"
				time[key] = 0 if wday[key].nil?
				time[key] += 1
			end
			weekdays = {"0" => "Sunday","1" => "Monday","2" => "Tuesday","3" => "Wednesday","4" => "Thursday","5" => "Friday","6" => "Saturday"}
			time = time.sort_by{|key,value| value}.reverse
			wday = wday.sort_by{|key,value| value}.reverse
			render text: "Most suitable time to post: " + time[0][0] + " and most suitable week day is: " + weekdays[wday[0][0]]
		else
			render text: "There was some error while authenticating"
		end
		
	end
end
