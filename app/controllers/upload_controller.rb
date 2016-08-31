# 文件与文件夹处理
class UploadController < ApplicationController

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
    @go_up=get_parent_dir(@dir) if @dir != "#{Rails.root.to_s}/public/"

    @dir_list,@file_list=get_dirs(@dir)
  end

  # 获取目录下的文件夹和文件
  def get_dirs(dir)
    dir_list, file_list = [], []
    Dir.foreach(dir) do |d|
      unless d == "." or d == ".." or d == ".svn"
        full_dir = dir+d
        dir_list << d if File.directory?(full_dir)
        file_list << d if File.file?(full_dir)
      end
    end
    return dir_list,file_list
  end

  # 获取当前的上一级目录
  def get_parent_dir(dir)
    arr=dir.split("/")
    arr.pop
    arr.join("/")+"/"
  end

  # 在当前目录下创建文件夹及文件
  def create
    @dir=params[:id]
    if params[:dir_name].present?
      if params[:dir_name].include?("&") or params[:dir_name].include?("=") or params[:dir_name].include?(".")
        flash[:notice] = "目录名称中含有非法字符"
        redirect_to_and_return
        return
      end
      child_dir = @dir + params[:dir_name]
      if File.directory?(child_dir)
        flash[:notice] = "此目录已经存在！"
      else
        Dir.mkdir(child_dir)
        flash[:notice] = "目录创建成功！"
      end
    end
    
    params[:files].each{|file| upload_file(file,@dir)} if params[:files].present?

    redirect_to_and_return
  end

  def redirect_to_and_return
    redirect_to "/upload?id=#{@dir}"
  end

  # 处理上传的文件
  # file上传文件, path上传到目录路径, new_filename上传文件的新名字
  def upload_file(file,path,new_filename=nil)
    max_size = 4096
    return "full" if file.size.to_f/1024 > max_size
    path += "/" unless path.end_with?("/")
    # 目录不存在创建目录
    Dir.mkdir(path) unless File.exists?(path)
    # 生成一个随机的文件名
    new_filename=Time.now.strftime("%Y%m%d%H%M%S") + "." + get_extname(file.original_filename) if new_filename.blank?
    # 向dir目录写入文件
    File.open("#{path+new_filename}", "wb") do |f|
      f.write(file.read)
    end

    # 解压文件
    if get_extname(file.original_filename)=~/zip/
      begin
        filenames = decompress(path+new_filename,path)
      rescue Zip::ZipError => e
        flash[:notice] = e
      end
    end

    return new_filename
  end

  # 获取文件扩展名
  def get_extname(filename="") 
    if filename =~ /\.(\w+)$/m
      $1
    else
      ""
    end
  end

  # 文件中文乱码问题
  def convert_filename(filename="")
    convertor=Iconv.new('UTF-8//IGNORE', 'GB2312')
    convertor.iconv(filename)
  end

  # 解压zip文件到指定目录
  # zip_filename 压缩文件名, decompress_path 解压到目录路径
  def decompress(zip_filename,decompress_path)
    zip=Zip::ZipFile.new(zip_filename)
    filenames=[]
    zip.entries.each do |e|
      # 保存中文名
      # name = convert_filename(e.name.split('/').last)
      name = Time.now.strftime("%Y%m%d%H%M%S")
      File.delete(decompress_path + name) if File.exist?(decompress_path + name)
      zip.extract(e, decompress_path + name)
      filenames << decompress_path + name
    end
    File.delete(zip_filename)
    filenames
  end

  # 删除文件或者文件夹
  def destroy
    @dir=get_parent_dir(params[:id])
    begin
      if File.directory?(params[:id])
        Dir.delete(params[:id])
      else
        File.delete(params[:id]) if File.exists?(params[:id])
      end
      flash[:notice] ="删除成功"
    rescue SystemCallError
      flash[:notice] = "该目录下还有文件不能删除！"
    end
    redirect_to_and_return
  end
end