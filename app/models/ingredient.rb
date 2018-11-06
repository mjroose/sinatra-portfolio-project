class Ingredient < ActiveRecord::Base
  has_many :recipes_ingredients
  has_many :recipes, through: :recipes_ingredients

  validates :name, presence: true
  validates :name, uniqueness: true

  def self.find_or_create_by_name_case_insensitive(name)
    Ingredient.where('lower(name) = ?', name.downcase).find_or_create_by(name: name)
  end
end