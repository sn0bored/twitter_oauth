get '/' do
  erb :index
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/auth' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  session.delete(:request_token)

  p @access_token.params
  puts @access_token.params[:screen_name]

  user = User.new(username: @access_token.params[:screen_name],
                  oauth_token: @access_token.params[:oauth_token],
                  oauth_secret: @access_token.params[:oauth_token_secret])
  user.save

  session[:user] = user.id
  erb :index
  
end

get '/status/:job_id' do
  # return the status of a job to an AJAX call
  job_is_complete(params[:job_id]).to_s
end

post '/tweet' do
  p params
  user = User.find(session[:user].to_i)
  user.tweet(params[:status], params[:time].to_i)
end
