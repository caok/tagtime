module Apis
  class BaseController < ApplicationController
    abstract!
    skip_before_action :verify_authenticity_token
    before_action :authenticate_user_from_token!, except: [:login, :authorize]

    def login
      user = User.find_for_database_authentication(email: params[:useremail])
      if user.blank?
        return render json: {type: 'fail'}
      end

      if user.valid_password?(params[:password])
        #sign_in user, store: false
        sign_in user
        user.ensure_token
        render json: {type: 'success', token:user.token}
      else
        render json: {type: 'fail', message: 'Invalid email or password!'}
      end
    end

    def authorize
      token = params[:token].presence
      user = token && User.find_by_token(token.to_s)

      if user.present?
        render json: {type: 'success'}
      else
        render json: {type: 'fail'}
      end
    end

    private
    def authenticate_user_from_token!
      if current_user
        @user = current_user and return
      end

      token = params[:token].presence
      user = token && User.find_by_token(token.to_s)
      if user.present?
        #sign_in user, store: false
        sign_in user
        @user = user
      else
        return render json: {type: 'fail'}
      end
    end
  end
end
