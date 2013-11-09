class EquipmentsController < BaseController
  inherit_resources
  #navigation :equipments

  def index
    @page = params[:page] || 1

    session[:category_id] = nil if params[:category_id] && params[:category_id].empty?
    if params[:category_id] && !params[:category_id].empty?
      session[:category_id] = params[:category_id]
      @category_id = params[:category_id].to_i
    elsif session[:category_id]
      @category_id = session[:category_id].to_i
    else
      @category_id = nil
    end

    @equipments = Equipment.scoped
    @equipments = @equipments.where(:category_id => @category_id) unless @category_id.blank?
    @equipments = @equipments.sorted.paginate(:page => params[:page])
  end

  def new
    @equipment = Equipment.new(:category_id => session[:category_id])
  end

  def create
    create!{ collection_path }
  end

  def update
    update!{ collection_path }
  end
end

