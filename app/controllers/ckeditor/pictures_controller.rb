class Ckeditor::PicturesController < ActionController::Base
  include OperateFiles
  def create
    init_shared
    this = Article.find_by_id(params[:id])
    path = "#{Rails.root.to_s}/public/ckeditor/articles/"
    path += "#{this.id}/" if this.present?
    callback_file = "/ckeditor/articles/"
    callback_file += this.id.to_s + "/" if this.present?
    begin
      newfile_name=upload_file(params[:upload],path) if params[:upload]
      render text: "<script>window.parent.CKEDITOR.tools.callFunction('#{@ckeditor_num}','#{callback_file}#{newfile_name}')</script>"
    rescue => e
      render text: e
    end

  end

  def index
    init_shared
    path = "#{Rails.root.to_s}/public/ckeditor/articles/"
    @relative_path = "/ckeditor/articles/"
    @dirs, @files = get_files(path)
  end

  def delete_file
    File.delete(params[:id]) if File.exist?(params[:id])
    redirect_to "/ckeditor/pictures?CKEditor=editor1&CKEditorFuncNum=1&langCode=zh-cn"
  end

  def init_shared
    @ckeditor = params[:CKEditor]
    @ckeditor_num = params[:CKEditorFuncNum]
    @lang_code = params[:langCode]
  end

  def upload_pic
    path = "#{Rails.root.to_s}/public/ckeditor/pictures/"
    begin
      newfile_name=upload_file(params[:file],path) if params[:file]
      render text: '/ckeditor/pictures/'+newfile_name
    rescue => e
      render text: e
    end
  end

end