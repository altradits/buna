class CurrenciesController < ApplicationController
  def switch
    currency = params[:currency].to_s.upcase
    if %w[KES ETB].include?(currency)
      session[:currency] = currency
      flash[:notice] = "Currency switched to #{currency == 'ETB' ? 'Ethiopian Birr (ETB ብር)' : 'Kenyan Shilling (KES KSh)'}."
    end
    redirect_back(fallback_location: root_path)
  end
end
