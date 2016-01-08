class ApplicationController < ActionController::Base
  rescue_from ::Exception, with: :error_occurred
  protect_from_forgery with: :exception

  def error_occurred(e)
    ErrorLog.create("system error", e.message)
    return
  end
end
