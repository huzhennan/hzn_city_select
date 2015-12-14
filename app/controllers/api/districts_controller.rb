module Api
  class DistrictsController < ApplicationController
    respond_to :json
    before_action :find_city


    def index
      @districts = @city.districts
      respond_with @districts
    end

    def show
    end

    private
    def find_city
      @city = City.find(params[:city_id])
    end
  end
end

