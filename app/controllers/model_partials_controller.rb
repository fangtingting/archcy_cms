class ModelPartialController < ApplicationController
  def index
    @these = ModelPartial.includes(:updator).page(params[:page]).per_page(20)
  end

  def new
    @this = ModelPartial.new
  end
end