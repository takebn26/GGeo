# BuildingsController
class BuildingsController < ApplicationController
  def index
    @buildings = Building.all
  end

  def new
    @building = Building.new
  end

  def create
    @building = Building.new(create_params)

    if @building.save
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def create_params
    params.require(:building).permit(:name, :address)
  end
end
