class StockItemsController < BaseController
  inherit_resources
  #navigation :stock_items_index

  def index
    @page = params[:page] || 1

    @equipment_id = params[:equipment_id].blank? ? nil : params[:equipment_id].to_i
    if params[:stock_id]
      session[:stock_id] = params[:stock_id]
      stock_id = params[:stock_id].to_i
    elsif session[:stock_id] && current_user.stocks.collect(&:id).include?(session[:stock_id].to_i)
      stock_id = session[:stock_id].to_i
    else
      stock_id = current_user.stocks.sorted.first
    end
    @stock = Stock.find_by_id(stock_id)

    session[:category_id] = nil if params[:category_id] && params[:category_id].empty?
    if params[:category_id] && !params[:category_id].empty?
      session[:category_id] = params[:category_id]
      @category_id = params[:category_id].to_i
    elsif session[:category_id]
      @category_id = session[:category_id].to_i
    else
      @category_id = nil
    end

    @date_from = Date.today - 1.month
    begin
      @date_from = params[:date_from].to_date
    rescue
    end

    @date_to = Date.today
    begin
      @date_to = params[:date_to].to_date
    rescue
    end

    @stock_items = StockItem.scoped
    @stock_items = @stock_items.where(:stock_id => @stock.id) if @stock
    @stock_items = @stock_items.where(:equipment_id => @equipment_id) unless @equipment_id.blank?
    @stock_items = @stock_items.where("stock_date BETWEEN :date_from AND :date_to",
      :date_from => @date_from, :date_to => @date_to)
    @stock_items = @stock_items.joins(:equipment).where(["equipment.category_id=?", @category_id]) if @category_id
    @stock_items = @stock_items.sorted.paginate(:page => params[:page]) if @stock
  end

  def new
    #current_navigation :stock_items_new
    @stock_item = StockItem.new(:stock_date => Date.today, :stock_id => session[:stock_id])
  end

  def create
    @stock_item = StockItem.new(params[:stock_item])
    @stock_item.user_id = current_user.id
    if @stock_item.save
      redirect_to collection_path
    else
      #current_navigation :stock_items_new
      render :action => 'new'
    end
  end

  def update
    @stock_item = StockItem.find(params[:id])
    @stock_item.user_id = current_user.id
    if @stock_item.update_attributes(params[:stock_item])
      redirect_to collection_path
    else
      render :action => 'edit'
    end
  end
end

