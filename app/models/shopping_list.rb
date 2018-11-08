class ShoppingList < ActiveRecord::Base
  has_many :shopping_list_recipes
  has_many :recipes, through: :shopping_list_recipes
  has_many :ingredients, through: :recipes
  has_many :foods, through: :ingredients

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
end