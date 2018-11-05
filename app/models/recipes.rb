class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :recipes_ingredients
  has_many :ingredients, through: :recipes_ingredients

  validates :name, presence: true
  validates :name, uniqueness: true

  def slug
    name.gsub(/\s/, "-")
  end

  def self.find_by_slug(slug)
    name = slug.gsub(/-/, " ")
    Recipe.find_by(name: name)
  end
end