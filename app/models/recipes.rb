class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :recipes_ingredients
  has_many :ingredients, through: :recipes_ingredients

  validates :name, presence: true

  def set_ingredients_from_params(params)
    if params.include? :ingredients
      cleaned_ingredients = params[:ingredients].find_all { |ingredient| ingredient[:name] != "" }

      self.recipes_ingredients = cleaned_ingredients.collect do |ingredient_line|
        RecipesIngredient.create({
          ingredient: Ingredient.find_or_create_by_name_case_insensitive(ingredient_line[:name]),
          quantity: ingredient_line[:quantity],
          unit: ingredient_line[:unit]
        })
      end
      
    else
      self.receipes_ingredients = []
    end
  end
end