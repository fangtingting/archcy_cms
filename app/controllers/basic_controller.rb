class BasicController < ApplicationController

  def model_class
    params[:controller].singularize.classify.constantize
  end

  def model_s
    params[:controller].singularize
  end

  def model_table
    model_class.tableize rescue nil
  end

  def show_path(obj)
    table_name = obj.class.name.tableize.pluralize
    "/#{table_name}/#{obj.id}"
  end

  def edti_path(obj)
    table_name = obj.class.name.tableize.pluralize
    "/#{table_name}/#{obj.id}/edit"
  end

  def index
    unless model_class
      begin
        return(render action: :index)
      rescue ActionView::MissingTemplate
        return(render template: 'basic/_blank')
      end
    end
    search_index
    render_shared
  end

  def render_shared(action=params[:action],*args)
    respond_to { |format|
      format.html { 
        begin
          render action: action
        rescue ActionView::MissingTemplate
          render template: "basic/_#{ action }"
        end 
      }
    }
  end

  def show
    @this = model_class.find_by_id(params[:id])
    render_shared
  end

  def new
    @this = model_class.new
    render_shared
  end

  def edit
    @this = model_class.find_by_id(params[:id])
    render_shared
  end

  def create
    @this=model_class.new(permit_params)
    respond_to { |format|
      begin
        if @this.save
          format.html {redirect_to @this}
        else
          format.html {render template: "basic/_new"}
        end
      rescue => e
        flash.now[:notice] = e.message
        format.html { render template: "basic/_#{@this.new_record? ? 'new' : 'edit'}" }
      end
    }
  end

  def update
    @this = model_class.find_by_id(params[:id])
    respond_to { |format|
      begin
        if @this.update(permit_params)
          format.html { redirect_to show_path(@this)}
          format.json {  respond_with_bip(this) }
        else
          format.html { render :template => "basic/_edit" }
          format.json  {  render :json => this.errors.full_messages.collect{|e|e.message}.join('<br>')}
          puts "ERROR: #{this.errors.full_messages}"
        end
      rescue => e
        format.html { render :template => "basic/_edit" }
        format.json {render :json => e.message }
      end
    }
  end

  private
  def permit_params
    params.require(:model_s).permit(:name)
  end

end