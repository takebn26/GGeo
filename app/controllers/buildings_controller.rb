# BuildingsController
class BuildingsController < ApplicationController
  def index
    @buildings = Building.all
    # Gmaps4rails.build_markersはhashの配列を生成する
    # 引数に渡した配列の数だけMarkerが作られる
    # View側で
    # markers = handler.addMarkers(<%=raw @hash.to_json %>);
    # をしてMapにMarker情報のJSONを渡す
    @hash = Gmaps4rails.build_markers(@buildings) do |building, marker|
      marker.lat building.latitude
      marker.lng building.longitude
    end
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
    params.require(:building).permit(:name, :country, :prefecture, :city, :detail_address)
  end
end
