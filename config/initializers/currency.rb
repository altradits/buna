# Currency & Regional Localization Initializer
module CurrencyHelper
  DEFAULT_KES_TO_ETB_RATE = 0.88 # 1 KES = 0.88 ETB
  DEFAULT_ETB_TO_KES_RATE = 1.136 # 1 ETB = 1.136 KES

  class << self
    def current_rate_kes_to_etb
      ENV.fetch("KES_TO_ETB_RATE", DEFAULT_KES_TO_ETB_RATE).to_f
    end

    def convert_kes_to_etb(kes_amount)
      return 0 if kes_amount.blank?
      (kes_amount.to_f * current_rate_kes_to_etb).round(2)
    end

    def convert_etb_to_kes(etb_amount)
      return 0 if etb_amount.blank?
      (etb_amount.to_f / current_rate_kes_to_etb).round(2)
    end

    def format_money(amount, currency = "KES")
      curr = currency.to_s.upcase
      formatted_num = amount.to_f.round(0).to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
      case curr
      when "KES"
        "KSh #{formatted_num}"
      when "ETB"
        "ETB #{formatted_num} (ብር)"
      else
        "#{curr} #{formatted_num}"
      end
    end
  end
end
