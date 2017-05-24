class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  layout 'admin'
  protect_from_forgery with: :exception
  before_action :set_model_partial
  before_action :set_this,only: [:show,:new,:edit,:create,:update,:delete]

  def model_class
    params[:controller].camelize.classify.constantize
  end

  def model_params
    params[:controller].gsub('/','_').singularize
  end

  def set_this
    @this = params[:id].present? ? model_class.find_by_id(params[:id]) : model_class.new
  end

  def new
    render "form"
  end

  def edit
    render "form"
  end

  def destroy
    @this.destroy
  end


  def render_shared
    render "application/_#{ @model_partial.main_layout}",layout: @model_partial.is_layout if @model_partial.present?
  end

  def set_model_partial
    @model_partial = ModelPartial.find_by_controller_and_action(params[:controller],params[:action])
    @html_title = @model_partial.html_title if @model_partial.present?
    @this = @model_partial.present? ? (params[:id] ? @model_partial.model_class.classify.constantize.find_by_id(params[:id]) : @model_partial.model_class.classify.constantize.new) : nil 
  end
  
  # def process_action *args
  #   time = Time.now
  #   super
  #   ur=UsersRequest.create(user_id: current_user.try(:id),url: request.url,time: (Time.now-time))
  # end

end
