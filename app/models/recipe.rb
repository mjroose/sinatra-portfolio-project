class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :ingredients
  has_many :foods, through: :ingredients
  has_many :shopping_list_recipes
  has_many :shopping_lists, through: :shopping_list_recipes
  has_many :instructions

  validates :name, presence: true

  def set_ingredients_from_params(params)
    self.clear_ingredients
    Ingredient.find_or_create_from_rows(self, params[:ingredients])
  end

  def set_instructions_from_params(params)
    self.clear_instructions
    Instruction.find_or_create_from_rows(self, params[:instructions])
  end

  def clear_instructions
    self.instructions = []
  end

  def clear_ingredients
    self.ingredients = []
  end
end