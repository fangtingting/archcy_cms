class Ckeditor::PicturesController < ActionController::Base
  include OperateFiles
  def create
    this = Article.find_by_id(params[:id])
    path = "#{Rails.root.to_s}/public/ckeditor/articles/"
    path += "#{this.id}/" if this.present?
    begin
      newfile_name=upload_file(params[:upload],path) if params[:upload]
      render text: '上传成功'
    rescue Exception => e
      render text: e
    end

  end

end