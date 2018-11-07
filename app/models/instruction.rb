class Instruction < ActiveRecord::Base
  belongs_to :recipe
  validates :content, presence: true

  def self.find_or_create_from_rows(recipe, rows = [])
    self.clean_rows(rows).each_with_index do |row,index|
      instruction = Instruction.find_or_create_by(
        recipe: recipe,
        content: row[:content]
      )
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