module Apis
  class BaseController < ApplicationController
    abstract!
    skip_before_action :verify_authenticity_token 
    before_action :audit

    def audit
      # TODO: need to remove `return true` 
      return true
      unless params[:sign] ==  ips_sign
        flash[:error] = "unaccepted sign!"
        respond_to do |format|
          format.html { redirect_to root_url, alert: flash[:error] } 
          format.json { render text: flash[:error] }
        end
      end
    end 

    def sign 
      # TODO: need to sign when user submit data
      sign_content = "sign_content"
      OpenSSL::Digest.hexdigest("MD5", sign_content)
    end
  end
end
