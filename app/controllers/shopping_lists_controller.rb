require './config/environment'

class ShoppingListsController < ApplicationController
  configure do
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'secret'
  end

  get '/shopping_lists' do
    if User.logged_in?(session) && user = User.current_user(session)
      @shopping_lists = user.shopping_lists
      erb :'/shopping_lists/index'
    else
      redirect to '/'
    end
  end

  get '/shopping_lists/new' do
    if User.logged_in?(session) && user = User.current_user(session)
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

  post '/shopping_lists' do
    if User.logged_in?(session) && user = User.current_user(session)
      user.shopping_lists.create_from_params(params[:recipe_ids])
      shopping_list = user.shopping_lists.last
      redirect to "/shopping_lists/#{shopping_list.id}"
    else
      redirect to '/'
    end
  end
end