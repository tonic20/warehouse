class UsersController < BaseController
  inherit_resources
  #navigation :users

  def create
    create!{ collection_path }
  end

  def update
    update!{ collection_path }
  end

  def change_password
    @user = User.find(params[:id])
  end

  protected
    def collection
      @users ||= end_of_association_chain.sorted.paginate(:page => params[:page])
    end
end

