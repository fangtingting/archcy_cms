# encoding: utf-8
module OperateFiles
  extend ActiveSupport::Concern

  included do
  end

  # 获取path下所有的文件夹名及文件名
  def get_files(path)
    dir_list, file_list = [], []
    Dir.foreach(path) do |d|
      unless d == "." or d == ".." 
        full_dir = path+d
        dir_list << d if File.directory?(full_dir)
        file_list << d if File.file?(full_dir)
      end
    end
    return dir_list,file_list
  end

  # 获取path的上一级路径
  def get_parent_path(path)
    arr=path.split("/")
    arr.pop
    arr.join("/")+"/"
  end

  # 在path下创建目录
  def create_dir(path,force=nil)
    raise "目录名称中含有非法字符" if path.include?("&") or path.include?("=") or path.include?(".")
    raise "此目录已经存在！" if force && File.directory?(path)
    Dir.mkdir(path) unless File.exist?(path)
  end

  # 上传文件并重命名,返回重名后的文件名
  # file上传文件, path上传到目录路径, new_filename上传文件的新名字
  def upload_file(file,path,max_size=4096,new_filename=nil)
    raise "文件太大" if file.size.to_f/1024 > max_size
    path += "/" unless path.end_with?("/")
    # 目录不存在创建目录
    Dir.mkdir(path) unless File.exist?(path)
    # 生成一个随机的文件名
    new_filename=Time.now.strftime("%Y%m%d%H%M%S") + File.extname(file.original_filename) if new_filename.blank?
    # 写入文件
    File.open("#{path+new_filename}", "wb") do |f|
      f.write(file.read)
    end
    return new_filename
  end

  # 上传文件但是不重命名
  def upload_original_file(file,path,max_size=4096)
    raise "文件太大" if file.size.to_f/1024 > max_size
    path += "/" unless path.end_with?("/")
    # 目录不存在创建目录
    Dir.mkdir(path) unless File.exist?(path)
    raise "文件已经存在!" if File.exist?("#{path}#{file.original_filename}")
    File.open("#{path+file.original_filename}", "wb") do |f|
      f.write(file.read)
    end
  end

  # 解压zip文件到指定目录，返回解压后的所有文件
  # zip_filename 压缩文件名, decompress_path 解压到目录路径
  def decompress(zip_filename,decompress_path)
    zip=Zip::ZipFile.new(zip_filename)
    filenames=[]
    zip.entries.each do |e|
      # 保存中文名
      # name = convert_filename(e.name.split('/').last)
      name = Time.now.strftime("%Y%m%d%H%M%S")+File.extname(e.name)
      File.delete(decompress_path + name) if File.exist?(decompress_path + name)
      zip.extract(e, decompress_path + name)
      filenames << name
    end
    # File.delete(zip_filename)
    filenames
  end

  # 文件中文乱码问题
  def convert_filename(filename="")
    convertor=Iconv.new('UTF-8//IGNORE', 'GB2312')
    convertor.iconv(filename)
  end

end