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

  get '/recipes/new' do
    if !User.logged_in?(session)
      redirect to '/'
    end

    erb :'/recipes/new'
  end

  get '/recipes/:id/edit' do
    @recipe = Recipe.find_by(id: params[:id])

    if !User.logged_in?(session) ||  User.current_user(session).id != @recipe.user.id
      redirect to '/'
    end

    erb :'/recipes/edit'
  end

  get '/recipes/:id' do
    @recipe = Recipe.find_by(id: params[:id])

    if !User.logged_in?(session) ||  User.current_user(session).id != @recipe.user.id
      redirect to '/'
    end
    
    erb :'/recipes/show'
  end

  post '/recipes' do
    if !User.logged_in?(session)
      redirect to '/'
    end

    if recipe = Recipe.create(name: params[:recipe][:name])
      recipe.set_ingredients_from_params(params)
      recipe.set_instructions_from_params(params)
      recipe.user = User.current_user(session)
      recipe.save

      redirect to "/recipes/#{recipe.id}"
    else
      redirect to 'recipes/new'
    end
  end

  patch '/recipes/:id' do
    recipe = Recipe.find_by(id: params[:id])

    if !User.logged_in?(session) ||  User.current_user(session).id != recipe.user.id
      redirect to '/'
    end

    if recipe
      if params[:name] && params[:name] != ""
        recipe.update(name: params[:name])
      end

      recipe.set_ingredients_from_params(params)
      recipe.set_instructions_from_params(params)
      recipe.save

      redirect to "/recipes/#{recipe.id}"
    else
      redirect to "/recipes"
    end    
  end

  delete '/recipes/:id' do
    recipe = Recipe.find_by(id: params[:id])

    if !User.logged_in?(session) ||  User.current_user(session).id != recipe.user.id
      redirect to '/'
    end

    if recipe
      recipe.destroy
    end

    redirect to '/recipes'
  end
end