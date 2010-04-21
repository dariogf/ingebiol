class JobsController < ApplicationController

 before_filter :get_parent

  def get_parent
	  begin
    	@command = Command.new(params[:command_id])
    	@user = session[:user_email]
    	if @user.nil?
    		flash[:error] = 'Not logged in'
    	end
    rescue Exception => e
    	  flash[:error] = 'No such command: '+params[:command_id]+'<br>'+e.message
    		redirect_to :controller=>'sessions', :action=>'errors'
    end
    #puts "command" + @command.to_json
  end

  # show a joblist
	def index
	  #puts "llegando"
	  # get paths
    data_path = File.join(DATA_PATH,@command.current_command,@user)
    script_path = File.join(USER_SCRIPTS_PATH,GET_JOBINFO_SCRIPT)
    titles_path = File.join(USER_SCRIPTS_PATH,JOBLIST_TITLES_JSON)
    
    #puts "Data PATH:" + data_path
    
    # Populate joblist
    @joblist = Joblist.new(data_path,script_path,titles_path)
    
     respond_to do |format|
      format.html #{ render :template => 'index.rjs' }
      format.js
      format.json  { render :json => @joblist.to_json }
      #format.xml  { render :xml => @joblist }
     end

	end
	
	def get_current_stage(params)
	    begin
	    		puts "GETTING CURRENT_STAGE: "+ params[:stage].to_s+'.'
	    		i=Integer(params[:stage]) # force number or nil
	    		if params[:stage].blank?
		    		@current_stage_pos = 1
	    		else
						@current_stage_pos = params[:stage].to_i
					end				
  	  #if @current_stage==nil
  	       @current_stage = @command.get_stage_names[@current_stage_pos-1]
  	  #end
  	rescue
    	@current_stage_pos=1    	
			@current_stage = @command.get_stage_names.first
  	end
  	
    puts "CURRENT STAGE:" + @current_stage

	end
  
  #-----------------------------------------
  # Display view to send a new command
  #-----------------------------------------  
  def new
    # puts "ejecutando accion gui/new"
    
    @current_job_id=params[:job_id] ||= 0
    
    get_current_stage(params)
    #puts "NEW"+@current_stage
  end
  
  #-----------------------------------------
  # Show a job by an id
  #-----------------------------------------
  def show
    @job_id=params[:id]

		data_path = File.join(DATA_PATH,@command.current_command,@user,@job_id)
		
		@job=Job.get_job_attrs(@command.current_command,@user,@job_id)
		
		#puts data_path+'/*'
     
    # modify current job id
    @current_job_id=@job_id
    
     respond_to do |format|
      format.html 
      format.js
      format.json  { render :json => Dir.glob(data_path+'/*').entries.collect{|e| File.basename(e)}.to_json }
      #format.xml  { render :xml => @joblist }
     end
  end
  
  #-----------------------------------------
  # Deletes a job by its id
  #-----------------------------------------
  def destroy
    @job_id=params[:id]
    
    # Delete job
    
    Job.delete(@command.current_command,@user,@job_id)
    
    # render :update do |page|
    # end
    
    respond_to do |format|
      format.html 
      format.js
      format.json  { render :json => 'DONE'.to_json }
      #format.xml  { render :xml => @joblist }
     end
    
  end
  
  #-----------------------------------------
  # upload first stage 
  #-----------------------------------------
  def create
    # puts "parametros, filename:", params[:upload][:filename].to_s
    
    @command_switches = ''
    
    @current_job_id=params[:job_id] ||= nil

   	get_current_stage(params)
   	
    # puts "parametros jobs:"+params.to_yaml

    
    # retrieve command configuration
       
    # at first, errors is an empty hash
    @errors = {}
    
    # check for errors
    @command.input_params_for_stage(@current_stage).each do |ui_param|
      if ui_param
	      ui_param.validate(params,@errors)
      end
    end
     
    # @errors = check_validation_errors(@command.input_params_for_stage(@current_stage))
                    
    # no errors, upload and retrieve params
    if @errors.empty?
      
      # if it is the first stage, create dir
      if (@current_stage==nil) or (@current_stage == @command.get_stage_names.first) or (@current_job_id==nil)
        
         # create new job directory
         @current_stage = @command.get_stage_names.first
         # get an unique id for the job if necessary
         @current_job_id = get_unique_id

      end
      
      puts "UPLOAD STAGE JOB_ID="+@current_job_id.to_s    

      std_attrs = {}
      @command_switches={}
      @command_switches[COMMAND_SWITCHES_TAG]=''
      
      # retrieve parameters values
      @command.input_params_for_stage(@current_stage).each do |ui_param|
         
         # ui_param.get_value
         field_value = ui_param.field_value(params)
         
         # save value to std_attrs
         ui_param.save_field_value(params,std_attrs)

         # save value
         ui_param.save_value(params,@command.current_command,@user,@current_job_id)
      
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
      Job.save_standard_attributes(std_attrs,@command.current_command,@user,@current_job_id)
      
      # puts "command switches "+command_switches
    
      # files are now uploaded if all went ok

      if @command.command_list(@current_stage)!=nil
        command_list = @command.command_list(@current_stage)
        use_queue_system = @command.use_queue_system(@current_stage)
        submit_command = @command.submit_command(@current_stage)
        sudo_command = @command.sudo_command(@current_stage)
        submit_file_header = @command.submit_file_header(@current_stage)
        
        #puts "sudo_command:" + sudo_command
        #puts "submit_command:" + submit_command
        
        path = File.join(DATA_PATH,@command.current_command,@user,@current_job_id)
        
        Command.exec_job_command(path,command_list,@command_switches,@current_job_id,use_queue_system,submit_command,sudo_command,submit_file_header)
      end
    
      old_stage=@current_stage
      
      @current_stage=@command.next_stage(@current_stage,@command_switches,@command.next_stage_flow(@current_stage))
      @current_stage_pos = @command.get_stage_names.index(@current_stage)+1
      
      #puts "CURRENT_STAGE:"+ [@current_stage,@current_stage_pos].join(',')
    
    end
    
    
    
    respond_to do |format|
      format.html {     # send response and ajax commands, they are in an external file
				responds_to_parent do
				  render :action => 'upload_stage.rjs'
				end
			 }
      format.js {     # send response and ajax commands, they are in an external file
				responds_to_parent do
				  render :action => 'upload_stage.rjs'
				end
			 }			 
      format.json  {
      				if @errors.empty?
      				 render :json => @current_job_id.to_json
      				else
      				render :json => @errors.to_json
      				end
      }
      #format.xml  { render :xml => @joblist }
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
    
    @current_stage = @command.get_stage_names.first
    
  end
  
  def visible_if
  end
end
