module Api
  class CitiesController < ApplicationController
    respond_to :json

    before_action :find_province

    def index
      @cities = @province.cities
      respond_with @cities
    end

    def show
    end

    private
    def find_province
      @province = Province.find(params[:province_id])
    end
  end
end