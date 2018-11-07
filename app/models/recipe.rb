class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :ingredients
  has_many :foods, through: :ingredients
  has_many :instructions

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

  def set_instructions_from_params(params)
    self.clear_instructions

    if params.include? :instructions
      Instruction.set_recipe_instructions_from_rows(self, params[:instructions])
    end
  end

  def clear_instructions
    self.instructions = []
  end
end