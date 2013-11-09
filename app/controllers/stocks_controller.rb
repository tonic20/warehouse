class StocksController < BaseController
  inherit_resources
  #navigation :stocks

  def create
    create!{ collection_path }
  end

  def update
    update!{ collection_path }
  end

  protected
    def collection
      @stocks ||= end_of_association_chain.sorted.paginate(:page => params[:page])
    end
end

