class Job  < BaseFileModel
                                        
                                        
  #-----------------------------------------
  # save standard attributes to a given user_id and job_id
  #-----------------------------------------
  def self.save_standard_attributes(attrs,current_command,user_id,job_id)
    
      job_path = File.join(DATA_PATH,current_command,user_id,job_id,STANDARD_ATTR_JSON)
        
        # read current attribute file
      if File.exists?(job_path)
        std_attr=BaseFileModel.get_json_data(job_path)
      end

      if !std_attr
          std_attr={}
      end

      # open file an write merged values 

      f = File.new(File.join(job_path),'w')
      f.write std_attr.merge(attrs).to_pretty_json
      f.close
      
  end    
  
  
  #-----------------------------------------
  # 
  #-----------------------------------------
  def self.create_unique_folder(current_command,user_id)

    
    id = 0
    user_path = File.join(DATA_PATH,current_command,user_id)
                                                    


    # puts "user_path:"+ user_path
                                                    
    today = Date.today.to_s
    today = today.gsub('-','')+'-'
    
    begin
      id=id+1

      work_path = File.join(user_path,today+id.to_s)

      # puts "Testing path:"+work_path
      
      
    end until !File.exists?(work_path)
    
    # puts "creating work path", work_path
    
    # make directory
    FileUtils.mkdir_p(work_path) unless File.exists?(work_path)
    
    # save standard attributes
                           
    std = {}
    std['user_id']=user_id
    std['job_id']=today+id.to_s
    
    self.save_standard_attributes(std,current_command,user_id,today+id.to_s)
    
    
    
    # puts "Created path:"+work_path

    return today+id.to_s
    
  end
  
  #-----------------------------------------
  # 
  #-----------------------------------------
  def self.delete(current_command,user_id,job_id)

    job_path = File.join(DATA_PATH,current_command,user_id,job_id)

    if File.exists?(job_path)
      if File.exist?(File.join(job_path,QUEUED_FILE))
      	# TODO - send qdel to pbs with job ID
      	      	
      end
      #FileUtils.rm_r(job_path,{:secure=>true})
      system('/bin/rm -rf '+job_path)
    end
    
  end
  
  def self.get_job_attrs(current_command,user_id,job_id)
  
	    job_path = File.join(DATA_PATH,current_command,user_id,job_id,STANDARD_ATTR_JSON)
        res ={}
        # read current attribute file
      if File.exists?(job_path)
        std_attr=BaseFileModel.get_json_data(job_path)        
      end
      
      return std_attr
      
  end
  
  
  
end
