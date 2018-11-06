class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :ingredients
  has_many :foods, through: :ingredients

  validates :name, presence: true

  def set_ingredients_from_params(params)
    if params.include? :ingredients
      cleaned_ingredients = params[:ingredients].find_all { |ingredient| ingredient[:food][:name] != "" }

      self.ingredients = cleaned_ingredients.collect do |ingredient|
        Ingredient.find_or_create_by(
          recipe: self,
          food: Food.find_or_create_by_name_case_insensitive(ingredient[:food][:name]),
          quantity: ingredient[:quantity],
          unit: ingredient[:unit]
        )
      end

    else
      self.ingredients = []
    end
  end
end