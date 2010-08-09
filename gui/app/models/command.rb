class Command < BaseFileModel
    
    
    attr_reader :current_command
    
  #-----------------------------------------
  # Creates a new command object that reads 
  # current config
  #-----------------------------------------
  def initialize(command_name=nil)
    
    #set current_command
    @current_command = command_name ||= DEFAULT_COMMAND
    
    # set current data path
    @current_command_path = File.join(COMMAND_CONFIG,@current_command)
    
    # load common data
    @common_data = get_json_data(File.join(@current_command_path,"common.json"))
    
    # load common data                                            
    @final_results = get_json_data(File.join(@current_command_path,"final_results.json"))
    
                  
    # extract stages
    @stage_list_files=extract_stage_list(@current_command_path)
    # puts "Loading stages", @stage_list_files.to_yaml
    @stage_list_names = []
                    
    # new hash
    @stage_data = {}
    
    # populate stage_data
    @stage_list_files.each do |stage|
      
      # decode json
      data = get_json_data(File.join(@current_command_path,stage))
      
      if data['enabled'] != false
        # save stage name without extension
        stage_name=File.basename(stage,File.extname(stage))
        @stage_list_names.push stage_name
        
        # save data in hash with stage name 
        @stage_data[stage_name] = UiFactory.create_objects(data)
      end
      
      # puts "STAGE:"+stage_name+";\n"+@stage_data[stage_name].to_yaml
      
    end
    
   #  puts self.to_yaml
    
  end
  
  def self.list_programs
	  #	return Dir.open(COMMAND_CONFIG).collect.reject{|e| ['.','..'].include?(e)}
	  res = []
	  info = {}

#  	Dir.glob(File.join(COMMAND_CONFIG,'*')).map{|d| File.basename(d)}.each do 
  	  Dir.glob(File.join(COMMAND_CONFIG,'*')).each do |cmd|
  	 		# load common data
     		common_data = get_json_data(File.join(cmd,"common.json"))
     		if common_data['in_dock'] != 'false'
		   		info['title']=common_data['title']
		   		info['tooltip']=common_data['long_description']
		   		info['command_id']=File.basename(cmd)
		   		
		   		
		   		res.push info
		   		info={}
     		end
     		
    end
    
  	
  	return res
  	
  end
  
  #-----------------------------------------
  # Extracts the list of stages defined in 
  # config directory 
  #-----------------------------------------
  def extract_stage_list(path)
                     
      # define list of ignored files/dirs
      # to_ignore = ['.','..','common.json','final_results.json']
            
      res = []
                              
      directories = Dir.glob(File.join(@current_command_path,STAGES_PATTERN)).sort

      # for each file in dir
      directories.each do |d|
        
        # add if not in ignore list
        # if to_ignore.index(d) == nil
          res.push File.basename(d)
        # end

      end
      
      return res
      
      # puts "Stages:"+ res.to_yaml
  end
  
  #-----------------------------------------
  # Returns an array with stages
  #-----------------------------------------
  def get_stage_files
     return @stage_list_files
  end
  
  #-----------------------------------------
  # Returns an array with stages
  #-----------------------------------------
  def get_stage_names
     return @stage_list_names
  end
                
  #-----------------------------------------
  # returns a hash with the stage data
  #-----------------------------------------
  def get_stage(stage)
    return @stage_data[stage]
  end
  #-----------------------------------------
  # Get a hash with data for one stage
  #-----------------------------------------
  def get_stage_data(stage,key)
    
    return get_stage(stage)[key]
    
  end
  
  def get_data(key)
    return @common_data[key]
  end
  
  def title
    return get_data('title')
  end
  
  def version
    return get_data('version')
  end
  
  
  def short_description
    return get_data('short_description')
  end
  
  #-----------------------------------------
  # 
  #-----------------------------------------
  def contact_url
    return get_data('contact_url')
    
  end             
  
  #-----------------------------------------
  # 
  #-----------------------------------------
  def copyright
    return get_data('copyright')
  end
  
  #-----------------------------------------
  # Returns path to a corporate logo
  #-----------------------------------------
  def corporate_logo
    return get_data('corporate_logo')
  end
  
  #-----------------------------------------
  # Returns path to a command logo
  #-----------------------------------------
  def command_logo
    return get_data('command_logo')
  end

  #-----------------------------------------
  # Returns path to a small corporate logo
  #-----------------------------------------
  def small_corporate_logo
    return get_data('small_corporate_logo')
  end
  
  #-----------------------------------------
  # Returns path to a small command logo
  #-----------------------------------------
  def small_command_logo
    return get_data('small_command_logo')
  end
  
  
  def long_description
    return get_data('long_description')
  end
  
  def links
    res = get_data('links')
    
    return res
  end
  
  def articles
    res = get_data('articles')
    
    return res
  end
  
  def articles_title
    res = get_data('articles_title')
    
    return res
  end
  #-----------------------------------------
  # Get the command to execute for a stage
  #-----------------------------------------
  def command_list(stage)
    return get_stage_data(stage,'command_list')
  end
  
  #-----------------------------------------
  # Get the queue status for a stage
  #-----------------------------------------
  def use_queue_system(stage)
    return get_stage_data(stage,'use_queue_system')
  end

  #-----------------------------------------
  # Get the queue status for a stage
  #-----------------------------------------
  def submit_file_header(stage)
    return get_stage_data(stage,'submit_file_header')
  end

  #-----------------------------------------
  # Get the queue status for a stage
  #-----------------------------------------
  def sudo_command(stage)
    return get_stage_data(stage,'sudo_command')
  end
  
  #-----------------------------------------
  # Get the queue status for a stage
  #-----------------------------------------
  def submit_command(stage)
    return get_stage_data(stage,'submit_command')
  end
  
  
  
  #-----------------------------------------
  # Get enable status for a stage
  #-----------------------------------------
  def stage_enabled(stage)
    return get_stage_data(stage,'enabled')
  end
  
  
  
  #-----------------------------------------
  # Get title of submit button for a stage
  #-----------------------------------------
  def submit_button_title(stage)
    return get_stage_data(stage,'submit_button_title')
  end
  
  
  #-----------------------------------------
  # Get flow for next stage calculation
  #-----------------------------------------
  def next_stage_flow(stage)
    return get_stage_data(stage,'next_stage_flow')
  end
  
  
  #-----------------------------------------
  # get input params for a stage
  #-----------------------------------------
  def input_params_for_stage(stage)
    return get_stage_data(stage,'input_params')
  end
  
  #-----------------------------------------
  # Returns the name of the next stage, 
  # or nil if not
  #-----------------------------------------
  def next_stage(stage,command_switches,next_stage_flow)

    current_index= get_stage_names.index(stage)
    
    begin
      current_index = current_index+1
      res = get_stage_names[current_index]
    end until ((res.nil?) or (stage_enabled(res)==true))
      

    #if there is a condition for next_stage
    
    if !next_stage_flow.blank?
      
      #evaluate condition
      next_stage_flow.keys.each do |nstage|
        puts nstage
        cond_text = next_stage_flow[nstage] ||= ''
                      
        #there is a condition
        if cond_text!=''
          cond_text = Command.replace_switches(cond_text,command_switches)
          
          #puts "exec_if:"+exec_if
          
          begin
            cond = eval(cond_text)
          rescue
            cond = false
          end
          
          if cond
            res = nstage
            
            break
          end
          
        end
        
      end
      
      #find new_stage
      #res = stage
    end
    
    if res.blank?
      res=get_stage_names.first
    end
    
    puts "selected next stage:#{res}"
    
    return res
    
  end
  
  #-----------------------------------------
  # Returns final results params
  #-----------------------------------------
  def get_final_results(user_id,job_id)
   # populate final results
   # user_id=sessions[:user_email]
   # user_id = params[:user_id]
   # job_id = params[:job_id]
   # user_id='a'
   # job_id='b'
   
   final_results = populate_final_results(user_id,job_id)
   
   return final_results 
  end
  
  #-----------------------------------------
  # populates final results with aditional data. 
  # Eg.: file size when necessary
  #-----------------------------------------
  def populate_final_results(user_id,job_id)
    
    results = @final_results.clone
    
    # puts "results1:"+results.to_yaml
        
    results['params'].each do |r|

      # calculate sizes of files and existence
      if r['type']=='file'
        file_path=File.join(DATA_PATH,@current_command,user_id,job_id,r['file'])
        
        if File.exist?(file_path)
          r['size']=File.size(file_path).to_human
          r['exists']=true
        else
          r['exists']=false
        end
      end
      
      if r['type']=='file_value'
        file_path=File.join(DATA_PATH,@current_command,user_id,job_id,r['file'])
        
        if File.exist?(file_path)
          
          file1 = File.open(file_path)
          text = file1.read
          file1.close
          
          # wipe text
          if text.match(r['regex'])
            r['value']=eval(r['regex_result'])
          end
          
          r['exists']=true
        else
          r['exists']=false
        end
      end
      
      
      if r['type']=='command_output'
        
        
        path = File.join(DATA_PATH,@current_command,user_id,job_id)
        
        cmd = 'cd '+path+';'+r['command']
        
        # TODO - OJO, ver si aqui podría ejecutarse comando chungo.
         res = `#{cmd}`
        
         r['value']=res.gsub("\n",'<br>' );

         
         r['exists']=true
      end
      
      if r['type']=='table_from_json'
        
        if !r['json_file'].nil?
          path = File.join(DATA_PATH,@current_command,user_id,job_id,r['json_file'])
                    
          r['value']=get_json_data(path)
  
          r['exists']=true  
        end
                
      end
      
    end
    
    # puts "results2:"+results.to_yaml
    
    return results
    
  end
  
  
  
  
  def self.replace_switches(cmd,command_switches)
    res = cmd
    
      # puts "original CMD: #{cmd}"
    
      # there are switches to replace
        if !command_switches.blank? and !cmd.blank?
          
           # replace command_switches in commands
           command_switches.keys.each do |switch|
              if !switch.blank?
               res.gsub!(/\$#{switch.gsub(/^\$/,'')}/i,command_switches[switch])
               #puts "replace :#{switch}: en :#{res}: por :#{command_switches[switch]}:"
              end
          end
          
           
          
        end
        
    return res
  end
  
  #-----------------------------------------
  # 
  #-----------------------------------------
  def self.exec_job_command(path, command_list, command_switches, job_id, queue,submit_command,sudo_command,submit_file_header)
   
    cmd_file = File.join(path,job_id+'.sh')
    
    # create exec file
    if (f = File.new(cmd_file,'w'))
   
      f.puts '#!/bin/bash'
      
      if (!submit_file_header.nil?) and (!submit_file_header.empty?)
      
      	submit_file_header.each do |line|
      	  	f.puts line
      	end
      
      else
      
				  # numero de cpus que empleara el calculo:
				  f.puts '#PBS -l select=ncpus=1'
				  # memoria que empleara el calculo:
				  f.puts '#PBS -l select=mem=2000mb'
				  # si se sabe cuanto va a tardar aproximadamente se debe indicar (10 horas en este caso) :
				  f.puts '#PBS -l walltime=10:00:00'
      
      end

      # para que vaya al directorio actual:
      if queue
        f.puts 'cd $PBS_O_WORKDIR'
      else
        # f.puts 'cd "'+path+'"'
      end

      #para darle permisos de lectura a wwwrun:
      f.puts 'umask 0003'

      #this file exists while it is running
      f.puts 'touch '+RUNNING_FILE
      f.puts 'rm '+QUEUED_FILE
      
      
      # put commands
      ntabs=0      
      
      command_list.each do |command_entry|
        
        exec_if = command_entry['exec_if'] ||= true
        
        #there is a condition
        if exec_if!=true
          exec_if = replace_switches(exec_if,command_switches)
          
          #puts "exec_if:"+exec_if
          
          begin
            exec_if = eval(exec_if)
          rescue
            exec_if = false
          end
          
          
          
        end
        
        #if !exec_if
        #  puts "Cmd not accepted"
        #end
        
        if exec_if
          #puts "cmd is accepted"
          required_files = command_entry['required_files']
          
          if (!required_files.nil?) and (!required_files.empty?)
            # if test -e $a/$b; then printf "exists"; fi
            
            required_files.each do |file|
              f.puts(('  ' * ntabs) + "if test -e #{file}; then")
              ntabs+=1
            end
  
          end
          
          # get command
          cmd = command_entry['command']
          
          cmd = replace_switches(cmd,command_switches)
                  
          # if (COMMAND_SWITCHES_TAG!='') and (command_switches != nil)
          #   cmd = cmd.gsub(COMMAND_SWITCHES_TAG,command_switches)
          # end
          
          
          f.puts(('  ' * ntabs) + cmd + '')
          
          
          if (!required_files.nil?) and (!required_files.empty?)
            # if test -e $a/$b; then printf "exists"; fi
            required_files.reverse.each do |file|
              
              f.puts(('  '*(ntabs-1)) + "else")
              f.puts(('  ' * ntabs) + 'echo "Command \"'+cmd+'\" not executed because file \"'+file+'\" doesn\'t exists" >> ERRORS.txt;')
              f.puts(('  '*(ntabs-1)) + 'fi')
              f.puts ''
              
              ntabs-=1
            end
            
  
          end
        end
      end
      
      # programa a ejecutar, con sus argumentos:
      # f.puts cmd
      
      #this file is deleted when done
      f.puts 'rm '+RUNNING_FILE
      
      f.close
      
      # send with queue
      if queue
        
        sd_cmd = sudo_command ||= QSUB_SUDO
        sm_cmd = submit_command ||= QSUB_CMD
        # ojo de no poner comillas y que no ponga path al fichero
        send_cmd = 'cd "' + path + '"; '+sd_cmd+' '+sm_cmd+' '+File.basename(cmd_file)+''
        touch_queued_cmd=sd_cmd+' touch "'+File.join(path,QUEUED_FILE)+'"'
      else
        send_cmd = 'cd "' + path + '"; '+LOCAL_SUDO+' '+LOCAL_CMD+' '+File.basename(cmd_file)+''
        touch_queued_cmd=LOCAL_SUDO+' touch "'+File.join(path,QUEUED_FILE)+'"'
      end
      
      puts "cmd_to_send: " + send_cmd
      
      if !system(touch_queued_cmd)
         puts "error en el touch QUEUED cmd"
      end
      
      if !system(send_cmd)
         puts "error en el system"
      end
                  
    end
    
  end
  
  
  
end
