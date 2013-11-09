class CategoriesController < BaseController
  inherit_resources
  #navigation :categories

  def create
    create!{ collection_path }
  end

  def update
    update!{ collection_path }
  end

  protected
    def collection
      @categories ||= end_of_association_chain.sorted.paginate(:page => params[:page])
    end
end

