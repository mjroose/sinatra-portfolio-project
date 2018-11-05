require './config/environment'

class RecipesController < ApplicationController
  configure do
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'secret'
  end

  get '/recipes' do
    if !User.logged_in?(session)
      redirect to '/'
    end

    @user = User.current_user(session)
    erb :'/recipes/index'
  end

  get '/recipes/:slug' do
    @recipe = Recipe.find_by_slug(params[:slug])

    if !User.logged_in?(session) ||  User.current_user(session).id != @recipe.user.id
      redirect to '/'
    end
    
    erb :'/recipes/show'
  end
end