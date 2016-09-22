# 文件与文件夹处理
class UploadController < ApplicationController
  # 文件及文件夹操作
  include OperateFiles

  # 显示public目录下的所有文件以及文件夹
  def index
    # 获取当前目录
    if params[:id].present?
      if params[:id].include?("..")
        flash[:notice]="非法路径" 
        redirect_to_and_return
        return
      end
      @dir = params[:id].split("/").join("/")+"/"
    else
      @dir = "#{Rails.root.to_s}/public/"
    end
    # 获取上级目录
    @go_up=get_parent_path(@dir) if @dir != "#{Rails.root.to_s}/public/"

    @dir_list,@file_list=get_files(@dir)
  end

  # 在当前目录下创建文件夹及文件
  def create
    @dir=params[:id]
    if params[:dir_name].present?
      child_dir = @dir + params[:dir_name]
      begin
        create_dir(child_dir)
        flash[:notice] = "目录创建成功！"
      rescue => e
        flash[:notice] = e.message
      end
    end
    if params[:files].present?
      begin
        params[:files].each do |file|
          # 上传并命名文件
          # new_filename=upload_file(file,@dir)
          # 解压文件
          # decompress(@dir+new_filename,@dir) if File.extname(file.original_filename)=~/zip/
          
          # 上传不重命名文件
          upload_original_file(file,@dir)
        end
        flash[:notice] = "上传成功"
      rescue => e
        flash[:notice] = e.message
      end
    end 

    redirect_to_and_return
  end

  def redirect_to_and_return
    redirect_to "/upload?id=#{@dir}"
  end


  # 删除文件或者文件夹
  def destroy
    @dir=get_parent_path(params[:id])
    begin
      if File.directory?(params[:id])
        Dir.delete(params[:id])
      else
        File.delete(params[:id]) if File.exists?(params[:id])
      end
      flash[:notice] ="删除成功"
    rescue => e
      flash[:notice] = e.message
    end
    redirect_to_and_return
  end
end