class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :orders, dependent: :nullify

  ROLES = %w[customer admin logistics_officer].freeze

  validates :role, inclusion: { in: ROLES }

  def admin?
    role == "admin"
  end

  def logistics?
    role == "logistics_officer" || admin?
  end

  def display_name
    full_name.presence || email.split("@").first.titleize
  end
end
