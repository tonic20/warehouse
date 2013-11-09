class ApplicationController < ActionController::Base
  include Authentication

  protect_from_forgery
  layout 'application'

  helper :all

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end
end

