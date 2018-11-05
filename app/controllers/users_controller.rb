require './config/environment'

class UsersController < ApplicationController
  configure do
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'secret'
  end

  get '/users/new' do
    if User.logged_in?(session)
      redirect to "/recipes"
    else
      erb :'/users/new'
    end
  end

  get '/users/login' do
    if User.logged_in?(session)
      redirect to "/recipes"
    else
      erb :'/users/login'
    end
  end

  get '/users/logout' do
    session.clear
    redirect to '/users/login'
  end

  post '/users' do
    user = User.new(username: params[:username], email: params[:email], password: params[:password])

    if user.save
      session[:user_id] = user.id

      redirect to "/recipes"
    else
      redirect to '/signup'
    end
  end

  post '/users/login' do
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to "/recipes"
    else
      @error_message = "Invalid user info."
      erb :'/users/login'
    end
  end

end