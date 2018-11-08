require './config/environment'

class ShoppingListsController < ApplicationController
  configure do
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'secret'
  end

  get '/shopping_lists' do
    if User.logged_in?(session) && user = User.find_by(id: session[:user_id])
      @shopping_lists = user.shopping_lists
      erb :'/shopping_lists/index'
    else
      redirect to '/users/login'
    end
  end
end