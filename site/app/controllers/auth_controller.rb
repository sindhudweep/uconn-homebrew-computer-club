class AuthController < ApplicationController
  def signin
    if request.post?
      session[:user] = User.authenticate(params[:email_address], params[:password]).id
      if session[:intended_controller] && session[:intended_action]
        redirect_to :action => session[:intended_action], :controller => session[:intended_controller]
      elsif session[:intended_controller]
        redirect_to :controller => session[:intended_controller]
      else
        redirect_to :controller => "greeter", :action => "about"
      end
    end
  end
  
  def signout
    session[:user] = nil
    redirect_to :controller => "greeter", :action => "about"
  end
end
