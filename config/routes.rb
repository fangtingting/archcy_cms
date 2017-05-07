Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  root 'dashboard#index'
  resources :model_partials

  match 'files_list' => 'common#files_list',via: [:get,:post,:delete]    
end

# 加载某个路径下的路由
# handle = Rails.env.production? ? method(:require) : method(:load)
# Dir.glob(File.join(Rails.root, 'config', 'routes', '*.rb'), &handle)