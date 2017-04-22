class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  
  # def process_action *args
  #   time = Time.now
  #   super
  #   ur=UsersRequest.create(user_id: current_user.try(:id),url: request.url,time: (Time.now-time))
  # end

end
