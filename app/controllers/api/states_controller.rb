module Api
  class StatesController < ApplicationController
    def index
      @states = State.all
      respond_with @states
    end
  end
end

