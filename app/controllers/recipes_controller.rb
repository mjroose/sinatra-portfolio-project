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

    @ingredients = Ingredient.all
    erb :'/recipes/new'
  end

  get '/recipes/:slug' do
    @recipe = Recipe.find_by_slug(params[:slug])

    if !User.logged_in?(session) ||  User.current_user(session).id != @recipe.user.id
      redirect to '/'
    end
    
    erb :'/recipes/show'
  end

  post '/recipes' do
    if !User.logged_in?(session)
      redirect to '/'
    end 

    recipe = Recipe.create(name: params[:recipe][:name])
    
    if recipe
      if params[:ingredients].include? :ids
        ingredients = params[:ingredients][:ids].collect do |ingredient_id|
          Ingredient.find_by(id: ingredient_id)
        end.compact
      else
        ingredients = []
      end

      if params[:ingredients].include? :names
        params[:ingredients][:names].each do |ingredient_name|
          ingredient = Ingredient.find_or_create_by(name: ingredient_name) unless ingredient_name == ""
          if ingredient
            ingredients << ingredient
          end
        end
      end

      binding.pry
      
      recipe.ingredients = ingredients.uniq
      recipe.user = User.current_user(session)
      recipe.save

      binding.pry
      redirect to "/recipes/#{recipe.slug}"
    else
      redirect to 'recipes/new'
    end
  end
end