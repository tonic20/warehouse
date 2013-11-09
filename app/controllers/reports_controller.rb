class ReportsController < BaseController
  def equipment
    #current_navigation :reports_equipment

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

    @expanded = params[:expanded]

    if request.post?
      @equipments = Equipment.equipment_by_stock(stock_id, @category_id, @date_from, @date_to)
    end
  end

  def equipment_summary
    #current_navigation :reports_equipment_summary

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

    @expanded = params[:expanded]

    @equipments = Equipment.equipment_summary(@category_id, @date_from, @date_to)
  end

  def equipment_history
    date_from = Date.today - 1.month
    begin
      date_from = params[:date_from].to_date
    rescue
    end

    date_to = Date.today
    begin
      date_to = params[:date_to].to_date
    rescue
    end

    equipment_id = params[:id]
    if params[:stock_id].blank?
      stock_items = StockItem.by_equipment(equipment_id, date_from, date_to)
    else
      stock_items = StockItem.by_equipment_and_stock(equipment_id, params[:stock_id], date_from, date_to)
    end
    render :partial => "history_items",
      :locals => {:stock_items => stock_items, :equipment_id => equipment_id}
  end
end

