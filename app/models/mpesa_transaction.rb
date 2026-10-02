class MpesaTransaction < ApplicationRecord
  belongs_to :order, optional: true

  STATUSES = %w[initiated pending success failed cancelled].freeze

  validates :status, inclusion: { in: STATUSES }
  validates :phone_number, :amount, presence: true

  scope :successful, -> { where(status: "success") }
  scope :recent, -> { order(created_at: :desc) }

  def success?
    status == "success" || result_code.to_i == 0
  end

  def failed?
    status == "failed" || (result_code.present? && result_code.to_i != 0)
  end

  def formatted_amount
    CurrencyHelper.format_money(amount, "KES")
  end
end
