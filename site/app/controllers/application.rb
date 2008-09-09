# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  layout "default", :except => [ :rss, :atom ]

  protect_from_forgery # :secret => '22b80e0b41432c8b68472b320bfa6bbb'
  
  
  before_filter :check_authentication, :check_authorization, :except => [:signin,:signout]
  
  def check_authentication
    unless session[:user]
      session[:intended_action] = action_name
      session[:intended_controller] = controller_name
      redirect_to :controller => "auth", :action => "signin"
      return false
    end
  end
  
  def check_authorization
    user = User.find(session[:user])
    unless user.roles.detect{|role|role.rights.detect{|right|right.action == action_name && right.controller == self.class.controller_path}}
      flash[:notice] = "You are not authorized to view the page you requested"
      request.env["HTTP_REFERER" ] ? (redirect_to :back) : (redirect_to home_url)
      return false
    end
  end
end
