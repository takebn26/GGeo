class LocationsController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :valify_csrf_token

  def index
    render json: { loc: Building.all }
  end

  def update
    building = Building.find(params[:id])

    if building.update(latitude: update_params[:lat], longitude: update_params[:lng])
      render json: building, status: 200
    else
      render json: { status: 500 }
    end
  end

  private

  def valify_csrf_token
    raise CSRFTokenError unless request.headers['X-CSRF-Token'] == 'A' * 10
  end

  def update_params
    params.permit(:lat, :lng)
  end
end
