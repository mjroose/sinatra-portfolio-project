class ShoppingList < ActiveRecord::Base
  belongs_to :user
  has_many :shopping_list_recipes
  has_many :recipes, through: :shopping_list_recipes
  has_many :ingredients, through: :recipes
  has_many :foods, through: :ingredients

  def recipe_list
    list = nil
    case self.recipes.count
    when 0
      list = ""
    when 1
      list = self.recipes.first.name
    when 2
      list = "#{self.recipes.first.name} and #{self.recipes.last.name}"
    else
      recipe_names = self.recipes.collect do |recipe|
        recipe.name
      end

      last_recipe_name = recipe_names.pop
      list = recipe_names.join(", ") + ", and " + last_recipe_name
    end
  end

  def name
    time_created = self.created_at.getlocal
    hour = time_created.strftime("%l").strip
    time_created.strftime("%A, %B %-d, %Y (#{hour}:%M %P)")
  end

  def food_names
    self.foods.collect do |food|
      food.name
    end
  end

  def foods
    self.ingredients.collect do |ingredient|
      ingredient.food
    end.uniq
  end

  def ingredients
    self.recipes.collect do |recipe|
      recipe.ingredients.collect do |ingredient|
        ingredient
      end
    end.flatten
  end

  def self.create_from_params(recipe_ids = [])
    shopping_list = self.new
    shopping_list.set_recipes_from_params(recipe_ids)
  end

  def set_recipes_from_params(recipe_ids = [])
    self.recipes = recipe_ids.collect do |recipe_id|
      Recipe.find_or_create_by(id: recipe_id)
    end

    self.save
  end
end