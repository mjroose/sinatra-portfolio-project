require './config/environment'

class UsersController < ApplicationController
  configure do
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'secret'
  end

  get '/signup' do
    if User.logged_in?(session)
      redirect to "/#{User.current_user(session).slug}"
    else
      erb :'/users/create_user'
    end
  end

  get '/login' do
    if User.logged_in?(session)
      redirect "/#{User.current_user(session).slug}"
    else
      erb :'/users/login'
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'/users/show'
  end

  get '/logout' do
    session.clear
    redirect to '/login'
  end

  post '/signup' do
    user = User.new(username: params[:username], email: params[:email], password: params[:password])

    if user.save
      session[:user_id] = user.id

      redirect to "/#{user.slug}"
    else
      redirect to '/signup'
    end
  end

  post '/login' do
    user = User.find_by(username: params[:username]) || User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to "/#{user.slug}"
    else
      @error_message = "Invalid user info."
      erb :'/users/login'
    end
  end

end