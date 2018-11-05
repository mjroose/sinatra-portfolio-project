class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :recipes_ingredients
  has_many :ingredients, through: :recipes_ingredients

  validates :name, presence: true
  validates :name, uniqueness: true
end