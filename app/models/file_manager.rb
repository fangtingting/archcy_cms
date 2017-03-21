class FileManager
  # root_folder_path:public目录,file_exts:允许的文件格式,file_max_size:文件最大的size,file_name:返回文件名,file_chinese_name:文件中文名
  attr_accessor :root_folder_path,:file_exts, :file_max_size, :file_name,:file_chinese_name

  def initialize(args={})
    self.root_folder_path = args[:root_folder_path] || "#{Rails.root.to_s}/public/files/"
    self.file_exts = args[:file_exts] || []
    self.file_max_size = args[:file_max_size] || 800
    self.file_chinese_name = args[:file_chinese_name] || "文件"
    upload_file(args[:file]) if args[:file].present?
  end

  # 文件所在父目录
  def expand_path
   Dir.mkdir(root_folder_path) unless File.exist?(self.root_folder_path)
   self.root_folder_path
  end

  # 文件所在子目录
  def file_folder
    Time.now.strftime("%Y-%m")
  end

  #文件路径（相对路径）
  def file_name_with_path
    Dir.mkdir(expand_path) unless File.exist?(self.root_folder_path)
    "#{self.file_folder}/#{self.file_name}"
  end 

  def upload_file(file)
    if !file.original_filename.empty?
      raise "#{self.file_chinese_name}必须小于#{self.file_max_size}k" if file.size > self.file_max_size.kilobytes
      file_ext = file.original_filename.split(".").last
      raise "上传的#{file_chinese_name.present}必须为#{self.file_exts.join(',')}格式！" if self.file_exts.include?(file_ext.downcase)
    end
  end

end