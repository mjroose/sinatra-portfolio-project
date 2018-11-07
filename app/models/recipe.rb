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
    self.instructions = []
    if params.include? :instructions
      cleaned_instructions = params[:instructions].find_all { |instruction| instruction[:content] != "" }

      self.instructions = cleaned_instructions.collect do |instruction|
        Instruction.find_or_create_by({
          recipe: self,
          content: instruction[:content],
          position: 0
        })
      end

      self.instructions.each do |instruction|
        instruction.set_position
      end
    end
  end
end