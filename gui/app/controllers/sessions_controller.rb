class SessionsController < ApplicationController

  # session controller does not need to be logged 
  skip_before_filter :login_required
    
  #-----------------------------------------
  # initialize a new session 
  #-----------------------------------------  
  def new
    
    # reset current session
    reset_session
    @command_id =(params[:id] ||= DEFAULT_COMMAND) 
    # load params of command from file
    begin
      flash[:error] = ''
      @command = Command.new(@command_id)
    rescue Exception => e  #ActiveSupport::JSON::ParserError
    
      # raise
      flash[:error] += "<br>Invalid json in configuration files.<br><br>"+ e.message 
      # flash[:error] += "<br>Error in json"
      render :action => 'errors'
    end
    
  end

  
  def create
        
    
    # load params of command from file
    @command = Command.new(params[:id] ||= DEFAULT_COMMAND)
    
    # create a user with passed params
    # params is a hash that is populated automatically by de form
    user = User.new(params['sessions'])
    
    
    valid = false
    
    if USE_LDAP_AUTH ==true
      if user.valid_user?
        valid = true
      end
      
    else
      # if mail is valid, login, if not, advise and retry
      if user.valid_email?
         valid = true
      end
      
    end
          
      # head
      
    if valid == true
      
      # save email in session info
      session[:user_email]= user.get_email
      #sesion[:current_stage]= @command.get_stage_names.first
            
      # welcome message
      flash[:notice] = "Welcome " + user.get_email
      
      # with ajax redirect to new page
      render :update do |page|
         page.redirect_to new_command_job_url(@command.current_command)
      end
    
    else
      
       # flash[:error] = "Invalid email!"
                                  
       # with ajax update page with invalid email
       render :update do |page|
         page[:InvalidEmail].replace_html('Invalid email')
         page[:loginDiv].visual_effect :shake
         # page[:InvalidEmail].visual_effect :highlight
       end

       
    end
       
  end
  
  #-----------------------------------------
  # 
  #-----------------------------------------
  def destroy
    
    reset_session
    
    flash[:notice] = "Logged out"    
    
    
    render :update do |page|
       page.redirect_to new_session_url
    end
    
    # render :action => new
    # redirect_to new_session_path
    

    
    # redirect_to :action => 'new', :layout => false
    
    # redirect_to :controller=>'sessions', :action => 'new', 
    # new
    # render :template => "sessions/new", :layout => false
    
    
  end
  
  def successfull_login
              
    # redirect_to :controller => :sessions, :action => :successfull_login
    
    render :action => :successfull_login
    
  end
      
end
