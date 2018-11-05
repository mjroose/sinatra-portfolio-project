class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :recipes_ingredients
  has_many :ingredients, through: :recipes_ingredients

  validates :name, presence: true
  validates :name, uniqueness: true

  def slug
    self.name.gsub(/\s/, "-")
  end

  def self.find_by_slug(slug)
    name = slug.gsub(/-/, " ")
    Recipe.find_by(name: name)
  end

  def set_ingredients_from_params(params)
    if params[:ingredients].include? :ids
      self.ingredients = params[:ingredients][:ids].collect do |ingredient_id|
        Ingredient.find_by(id: ingredient_id)
      end.compact
    else
      self.ingredients = []
    end

    if params[:ingredients].include? :names
      self.ingredients += params[:ingredients][:names].collect do |ingredient_name|
        Ingredient.find_or_create_by(name: ingredient_name) unless ingredient_name == ""
      end.compact
    end

    self.ingredients = self.ingredients.uniq
  end
end