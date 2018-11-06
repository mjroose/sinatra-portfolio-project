class Food < ActiveRecord::Base
  has_many :ingredients
  has_many :recipes, through: :ingredients

  validates :name, presence: true
  
  def self.find_or_create_by_name_case_insensitive(name)
    self.where('lower(name) = ?', name.downcase).find_or_create_by(name: name)
  end
end