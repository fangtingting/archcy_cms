class ArticlesController < ApplicationController

  def index
    params[:q] ||={}
    @search = Article.search(params[:q])
    @articles = @search.result.order("created_at desc").page(params[:page]).per_page(20)
  end

  def new
    @article=Article.new
  end

  # 获取当前目录下的文件及文件夹
  def files_list
    params[:current_dir] ||= "#{Rails.root.to_s}/public/files/" 
    @dir = (params[:current_dir].end_with?("/") ? params[:current_dir] : params[:current_dir] + "/")
    begin
      if request.post?
        Common::FileManager.create_dir(@dir+params[:dir_name]+"/") if params[:dir_name].present?
        Common::FileManager.new(root_folder_path: @dir,original_file: params[:file_name]) if params[:file_name].present?
      elsif request.delete?
        Dir.delete(params[:delete_dir]) if params[:delete_dir].present? && File.directory?(params[:delete_dir])
        File.delete(params[:delete_file]) if params[:delete_file].present? && File.exists?(params[:delete_file])
      end
    rescue  => e
      flash.now[:notice] = e
    end
    @dir_list,@file_list=Common::FileManager.get_files(@dir)
  end

end