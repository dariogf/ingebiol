# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  helper :all # include all helpers, all the time
  
  # uncomment next line to force login before any page is viewed
  before_filter :login_required
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  #protect_from_forgery :only => [:update, :delete, :create]
 # :secret => '6a85cd0817a3b783592f18c9eb02966a'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  

  # this method determines if the user is logged or not
  def login_required
     cmd = params[:command_id].to_s
     #puts "params_login:"+ params.to_json
     if !params['api_login_key'].nil?
	     session[:user_email] = params['api_login_key']
	#     puts "Logging with API_K"
    # puts "Entering login required"
    else
# 	     puts "Logging with session"
 	     
		  if (session[:user_email].blank?)
		    flash[:notice] = 'Please log in'
		    if !cmd.blank?
		    	redirect_to(new_session_url+'/'+cmd)
		    else
		    	redirect_to new_session_url		    
		    end
		  end
		end    
  end  
    
end
