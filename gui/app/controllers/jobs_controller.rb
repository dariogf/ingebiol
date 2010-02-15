class JobsController < ApplicationController

 before_filter :get_parent

  def get_parent
    @command = Command.new(params[:command_id])
    @user = session[:user_email]
    #@command = params[:command_id]
    #puts "command" + @command.to_json
  end

  # show a joblist
	def index
	  #puts "llegando"
	    # get paths
    data_path = File.join(DATA_PATH,@command.current_command,@user)
    script_path = File.join(USER_SCRIPTS_PATH,GET_JOBINFO_SCRIPT)
    titles_path = File.join(USER_SCRIPTS_PATH,JOBLIST_TITLES_JSON)
    
    puts "Data PATH:" + data_path
    
    # Populate joblist
    @joblist = Joblist.new(data_path,script_path,titles_path)
    
	end
  
  #-----------------------------------------
  # Display view to send a new command
  #-----------------------------------------  
  def new

    # puts "ejecutando accion gui/new"
    session[:current_job_id]=nil
    #@command = Command.new(session[:current_command])
    
    if session[:current_stage]==nil
         session[:current_stage] = @command.get_stage_names.first
    end
    
  end
  
  #-----------------------------------------
  # Show a job by an id
  #-----------------------------------------
  def show
    @job_id=params[:id]
    #@command = Command.new(session[:current_command])
        
    # modify current job id
    session[:current_job_id]=@job_id
  end
  
  #-----------------------------------------
  # Deletes a job by its id
  #-----------------------------------------
  def delete
    @job_id=params[:id]
    
    # Delete job
    
    Job.delete(@command.current_command,@user,@job_id)
    
    # render :update do |page|
    # end
  end
  
  #-----------------------------------------
  # 
  #-----------------------------------------
  def upload_stage
    # puts "parametros, filename:", params[:upload][:filename].to_s
    
    @command_switches = ''
    
    # puts "parametros jobs:"+params.to_yaml
    
    # retrieve command configuration
    #@command = Command.new(session[:current_command])
    
    
    # check stage is valid
    if (session[:current_stage].blank?)
         # create new job directory
         session[:current_stage] = @command.get_stage_names.first
    end
    
       
    # at first, errors is an empty hash
    @errors = {}
    
    # check for errors
    @command.input_params_for_stage(session[:current_stage]).each do |ui_param|
      ui_param.validate(params,@errors)
    end
     
    # @errors = check_validation_errors(@command.input_params_for_stage(session[:current_stage]))
                    
    # no errors, upload and retrieve params
    if @errors.empty?
      
      # if it is the first stage, create dir
      if (session[:current_stage]==nil) or (session[:current_stage] == @command.get_stage_names.first)
        
         # create new job directory
         session[:current_stage] = @command.get_stage_names.first
         # get an unique id for the job if necessary
         session[:current_job_id] = get_unique_id
      end
    

      std_attrs = {}
      @command_switches={}
      @command_switches[COMMAND_SWITCHES_TAG]=''
      
      # retrieve parameters values
      @command.input_params_for_stage(session[:current_stage]).each do |ui_param|
         
         # ui_param.get_value
         field_value = ui_param.field_value(params)
         
         # save value to std_attrs
         ui_param.save_field_value(params,std_attrs)

         # save value
         ui_param.save_value(params,@command.current_command,@user,session[:current_job_id])
      
         # retrieve command switches
         cs = ui_param.command_switch(field_value)
         
         @command_switches[ui_param.field_switch] = cs
         
         if cs != ''
           @command_switches[COMMAND_SWITCHES_TAG] += (' ' + cs) 
         end         
         
      end
      
      #puts @command_switches.to_yaml

      std_attrs[COMMAND_SWITCHES_TAG]=@command_switches[COMMAND_SWITCHES_TAG]
      #save values
      Job.save_standard_attributes(std_attrs,@command.current_command,@user,session[:current_job_id])
      
      # puts "command switches "+command_switches
    
      # files are now uploaded if all went ok

      if @command.command_list(session[:current_stage])!=nil
        command_list = @command.command_list(session[:current_stage])
        use_queue_system = @command.use_queue_system(session[:current_stage])
        submit_command = @command.submit_command(session[:current_stage])
        sudo_command = @command.sudo_command(session[:current_stage])
        submit_file_header = @command.submit_file_header(session[:current_stage])
        
        #puts "sudo_command:" + sudo_command
        #puts "submit_command:" + submit_command
        
        path = File.join(DATA_PATH,@command.current_command,@user,session[:current_job_id])
        
        Command.exec_job_command(path,command_list,@command_switches,session[:current_job_id],use_queue_system,submit_command,sudo_command,submit_file_header)
      end
    
      old_stage=session[:current_stage]
      
      session[:current_stage]=@command.next_stage(session[:current_stage],@command_switches,@command.next_stage_flow(session[:current_stage]))

      #if session[:current_stage]==nil
      #    session[:current_stage] = @command.get_stage_names.first
      #end
      #
      if old_stage!= session[:current_stage]
        session[:previous_stage]=old_stage
      end
    
    end
    
    # send response and ajax commands, they are in an external file
    responds_to_parent do
      render :action => 'upload_stage.rjs'
    end

  end
  
  #-----------------------------------------
  # 
  #-----------------------------------------
  def get_unique_id
    res = ''
    
    if @user
      res = Job.create_unique_folder(@command.current_command,@user)
    end
    
    return res
    
  end
  
  #-----------------------------------------
  # 
  #-----------------------------------------
  def reset_stage
    @command = Command.new(@command.current_command)
    
    session[:current_stage] = @command.get_stage_names.first
    
  end
  
  def visible_if
  end
end
