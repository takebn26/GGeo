class ApplicationController < ActionController::Base

  rescue_from CSRFTokenError, with: :return_404_json

  private

  def return_404_json
    render json: { status: 404 }.to_json
  end
end
