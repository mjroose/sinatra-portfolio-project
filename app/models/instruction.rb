class Instruction < ActiveRecord::Base
  belongs_to :recipe
  validates :content, presence: true

  def set_position
    recipe_id = self.recipe.id

    recipe_instructions = Instruction.all.find_all do |instruction|
      recipe_id == instruction.recipe.id
    end
    
    if recipe_instructions != nil && recipe_instructions.size > 1
      self.position = recipe_instructions.sort { |a, b| a.position <=> b.position }.last.position + 1
    else
      self.position = 1
    end
    self.save
  end
end