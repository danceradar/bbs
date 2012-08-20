# coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authorize, :current_user
  
  protected
  	def authorize
  		unless User.find_by_id(session[:user_id])
  			redirect_to signin_url, notice:"用户请先登录"
  		end
  	end

  	def current_user
  		@current_user = User.find(session[:user_id])
  	end
end
