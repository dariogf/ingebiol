class JobsController < ApplicationController
  
  #-----------------------------------------
  # 
  #-----------------------------------------  
  def new
    # puts "ejecutando accion gui/new"
    session[:current_job_id]=nil
        
    @command = Command.new(session[:current_command])
    
    if session[:current_stage]==nil
         session[:current_stage] = @command.get_stage_names.first
    end
    
  end
  
  #-----------------------------------------
  # Show a job by an id
  #-----------------------------------------
  def show
    @job_id=params[:id]
    @command = Command.new(session[:current_command])
        
    # modify current job id
    session[:current_job_id]=@job_id
  end
  
  #-----------------------------------------
  # Deletes a job by its id
  #-----------------------------------------
  def delete
    @job_id=params[:id]
    
    # Delete job
    
    Job.delete(session[:current_command],session[:user_email],@job_id)
    
    # render :update do |page|
    # end
  end
  
  #-----------------------------------------
  # 
  #-----------------------------------------
  def upload_stage
    # puts "parametros, filename:", params[:upload][:filename].to_s
    
    command_switches = ''
    
    # puts "parametros jobs:"+params.to_yaml
    
    # retrieve command configuration
    @command = Command.new(session[:current_command])
    
    # check stage is valid
    if (session[:current_stage]==nil) or (session[:current_stage] == '')
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
      command_switches={}
      command_switches[COMMAND_SWITCHES_TAG]=''
      
      # retrieve parameters values
      @command.input_params_for_stage(session[:current_stage]).each do |ui_param|
         
         # ui_param.get_value
         field_value = ui_param.field_value(params)
         
         # save value to std_attrs
         ui_param.save_field_value(params,std_attrs)

         # save value
         ui_param.save_value(params,session[:current_command],session[:user_email],session[:current_job_id])
      
         # retrieve command switches
         cs = ui_param.command_switch(field_value)
         
         command_switches[ui_param.field_switch] = cs
         
         if cs != ''
           command_switches[COMMAND_SWITCHES_TAG] += (' ' + cs) 
         end         
         
      end
      
      puts command_switches.to_yaml

      std_attrs[COMMAND_SWITCHES_TAG]=command_switches[COMMAND_SWITCHES_TAG]
      #save values
      Job.save_standard_attributes(std_attrs,session[:current_command],session[:user_email],session[:current_job_id])
      
      # puts "command switches "+command_switches
    
      # files are now uploaded if all went ok

      if @command.command_list(session[:current_stage])!=nil
        command_list = @command.command_list(session[:current_stage])
        use_queue_system = @command.use_queue_system(session[:current_stage])

        path = File.join(DATA_PATH,session[:current_command],session[:user_email],session[:current_job_id])
        
        Command.exec_job_command(path,command_list,command_switches,session[:current_job_id],use_queue_system)
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
    
    if session[:user_email]
      res = Job.create_unique_folder(session[:current_command],session[:user_email])
    end
    
    return res
    
  end
  
  #-----------------------------------------
  # 
  #-----------------------------------------
  def reset_stage
    @command = Command.new(session[:current_command])
    
    session[:current_stage] = @command.get_stage_names.first
    
  end
end
