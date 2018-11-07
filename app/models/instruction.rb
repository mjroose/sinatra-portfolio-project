class Instruction < ActiveRecord::Base
  belongs_to :recipe
  validates :content, presence: true

  def self.set_recipe_instructions_from_rows(recipe, instruction_rows)
      instructions = Instruction.find_or_create_from_rows(recipe, instruction_rows)
  end

  def self.clear_recipe_ingredients(recipe)
    recipe.instructions = []
  end

  def self.find_or_create_from_rows(recipe, rows)
    cleaned_rows = self.clean_rows(rows)
    
    instructions = cleaned_rows.each_with_index do |row|
      Instruction.find_or_create_by({
        recipe: recipe,
        content: row[:content]
        position: index + 1
      })
    end

    self.assign_positions(instructions)
  end

  def self.assign_positions(instructions)
    instructions.each_with_index do |instruction, index|
      instruction.position = index + 1
      instruction.save
    end
  end

  def self.clean_rows(rows)
    rows.find_all do |instruction|
      instruction[:content] != ""
    end
  end
end