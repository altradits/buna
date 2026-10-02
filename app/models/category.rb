class Category < ApplicationRecord
  has_many :products, dependent: :destroy

  validates :name, presence: true
  validates :amharic_name, presence: true
  validates :slug, presence: true, uniqueness: true

  before_validation :generate_slug, on: :create

  scope :ordered, -> { order(sort_order: :asc, name: :asc) }

  def to_param
    slug
  end

  private

  def generate_slug
    self.slug ||= name.to_s.parameterize if name.present?
  end
end
