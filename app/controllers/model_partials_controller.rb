class ModelPartialsController < ApplicationController
  def index
    @these = ModelPartial.page(params[:page]|| 1).per_page(20)
    render_shared
  end

  def create
    @this = ModelPartial.new(params[:model_partial].permit!)
    if @this.save
      redirect_to model_partials_path
    else
      render :new
    end
  end

  def update
    if @this.update(params[:model_partial].permit!)
      redirect_to model_partials_path
    else
      render :edit
    end
  end
end