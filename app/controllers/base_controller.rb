require "application_responder"

class BaseController < ApplicationController
  self.responder = ApplicationResponder
  respond_to :html

  before_filter :login_required
end

