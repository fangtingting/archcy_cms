# 用于上传文件操作,获取文件目录,解压目录
class Common::FileManager
  # root_folder_path:public目录,file_exts:允许的文件格式,file_max_size:文件最大的size,file_name:返回文件名,file_chinese_name:文件中文名
  attr_accessor :root_folder_path,:file_exts, :file_max_size, :file_name,:file_chinese_name

  def initialize(args={})
    self.root_folder_path = args[:root_folder_path] || "#{Rails.root.to_s}/public/files/"
    self.file_exts = args[:file_exts] || []
    self.file_max_size = args[:file_max_size] || 800
    self.file_chinese_name = args[:file_chinese_name] || "文件"
    upload_file(args[:file]) if args[:file].present?
    upload_original_file(args[:original_file]) if args[:original_file].present?
  end

  # 文件所在父目录
  def expand_path
   Dir.mkdir(self.root_folder_path) unless File.exist?(self.root_folder_path)
   self.root_folder_path = self.root_folder_path + "/" unless self.root_folder_path.end_with?("/")
   self.root_folder_path
  end

  # 文件所在日期子目录
  def file_folder
    if @file_folder.blank?
      @file_folder = Time.now.strftime("%Y-%m/")
      Dir.mkdir(expand_path+@file_folder) unless File.exist?(expand_path+@file_folder)
    end
    @file_folder
  end

  #重命名文件路径（相对路径）,最后就是调用这个方法获取文件保存路径保存到数据库
  def file_name_with_path
    file_folder + self.file_name
  end 

  # 不重名文件路径(绝对路径)
  def original_file_name_with_path
    expand_path + self.file_name
  end

  # 上传文件并重命名
  def upload_file(file)
    if !file.original_filename.empty?
      raise "#{self.file_chinese_name}必须小于#{self.file_max_size}k" if file.size > self.file_max_size.kilobytes
      
      file_ext = file.original_filename.split(".").last
      raise "上传的#{file_chinese_name}必须为#{self.file_exts.join(',')}格式！" unless self.file_exts.blank? or self.file_exts.include?(file_ext.downcase)

      self.file_name = Time.now.strftime("%d%H%M%S") + "_#{rand(10000)}" + '.' + file_ext
      kill_file # 删除重复文件
      File.open(expand_path+file_folder+self.file_name, 'wb') { |f| f.write(file.read) } # 写入文件
    end
  end

  # 上传文件但是不重命名,这个方法只需要root_folder_path参数
  def upload_original_file(file)
    if !file.original_filename.empty?
      raise "#{self.file_chinese_name}必须小于#{self.file_max_size}k" if file.size > self.file_max_size.kilobytes
      
      file_ext = file.original_filename.split(".").last
      raise "上传的#{file_chinese_name}必须为#{self.file_exts.join(',')}格式！" unless self.file_exts.blank? or self.file_exts.include?(file_ext.downcase)
      raise "文件已经存在!" if File.exist?("#{expand_path}#{file.original_filename}")
      self.file_name = file.original_filename
      File.open(expand_path+self.file_name,'wb') {|f| f.write(file.read)}
    end
  end

  def kill_file
    File.delete(expand_path+file_folder+self.file_name) if self.file_name.present? && File.exist?(expand_path+file_folder+self.file_name)
  end


  # 主要是目录管理操作
  class << self

    # 在path下创建目录
    def create_dir(path)
      raise "目录名称中含有非法字符" if path.include?("&") or path.include?("=") or path.include?(".")
      raise "此目录已经存在！" if File.directory?(path)
      path += "/" unless path.end_with?("/")
      Dir.mkdir(path) unless File.exist?(path)
    end

    # 获取path下所有的文件夹名及文件名
    def get_files(path)
      dir_list, file_list = [], []
      Dir.foreach(path) do |d|
        unless d == "." or d == ".." 
          dir_list << d if File.directory?(path+d)
          file_list << d if File.file?(path+d)
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

    # 解压zip文件到指定目录，返回解压后的所有文件（这个方法还需重构）
    # zip_filename 压缩文件名, decompress_path 解压到目录路径
    def decompress(zip_filename,decompress_path)
      zip=Zip::ZipFile.new(zip_filename)
      filenames=[]
      zip.entries.each do |e|
        name = Time.now.strftime("%Y%m%d%H%M%S")+File.extname(e.name)
        File.delete(decompress_path + name) if File.exist?(decompress_path + name)
        zip.extract(e, decompress_path + name)
        filenames << name
      end
      filenames
    end

  end

end