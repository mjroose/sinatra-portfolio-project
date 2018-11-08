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
      redirect to '/'
    end
  end

  get '/shopping_lists/new' do
    if User.logged_in?(session) && user = User.find_by(id: session[:user_id])
      @recipes = user.recipes
      erb :'/shopping_lists/new'
    else
      redirect to '/'
    end
  end

  get '/shopping_lists/:id' do
    if @shopping_list = ShoppingList.find_by(id: params[:id]) 
      if !User.logged_in?(session) ||  User.current_user(session).id != @shopping_list.user.id
        redirect to '/'
      end

      erb :'/shopping_lists/show'

    else
      redirect to '/shopping_lists'
    end
  end
end