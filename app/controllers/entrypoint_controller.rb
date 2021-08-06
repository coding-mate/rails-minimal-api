class EntrypointController < ApplicationController
  def index
    render json: {message: "ok"}
  end
end
