module Api
  class ProvincesController < ApplicationController
    respond_to :json

    def index
      @provinces = Province.all
      respond_with @provinces
    end
  end
end

