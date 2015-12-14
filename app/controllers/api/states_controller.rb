module Api
  class StatesController < ApplicationController
    respond_to :json

    def index
      @states = State.all
      respond_with @states
    end
  end
end

