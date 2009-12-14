class Joblist < BaseFileModel

  
  #-----------------------------------------
  # Creates a new command object that reads 
  # current config
  #-----------------------------------------
  def initialize(data_path,script_path,titles_path)
    
    # @data_dir = "public/data/"
    
    # retrieve titles
    @titles = []
    
    if File.exists?(titles_path)
      @titles = get_json_data(titles_path)
    end
    
    @data = []
    
    if File.exists?(data_path)
      @data = collect_joblist(data_path,script_path)
    end

  end
  
  #-----------------------------------------
  # 
  #-----------------------------------------
  def get_titles
    return @titles
  end
  
  
  #-----------------------------------------
  # 
  #-----------------------------------------
  def get_data
    return @data
  end
  
    
  #-----------------------------------------
  # Extracts the list of stages defined in 
  # config directory 
  #-----------------------------------------
  def collect_joblist(data_path,script_path)
                     
      # define list of ignored files/dirs
      to_ignore = ['.','..','.DS_Store']
      
      res = []
      
      # open dir
      directory=Dir.open(data_path)
      
      # for each file in dir
      directory.each do |d|
        
        # add if not in ignore list
        if to_ignore.index(d) == nil
                                          
          # get standard attributes if file exists
          std_attr = {}
          if File.exists?(File.join(data_path,d,STANDARD_ATTR_JSON))
            std_file=get_json_data(File.join(data_path,d,STANDARD_ATTR_JSON))
            
            if !std_file.nil?
	            std_attr=std_file
            end
            
            #puts "STDATTR:"+std_attr.to_yaml
          end
	
          
          # id is always current directory
          std_attr['job_id']=d
          
          # there is a script for job info
          if File.exists?(script_path)
		puts "populate joblist data"

            # populate data with it
            command = script_path + ' ' + File.join(data_path,d)
            job_text=`#{command}`

            if job_text!=''

              obj = ActiveSupport::JSON.decode(job_text)
              
              if !obj.empty?
                if !std_attr.empty?
                  obj=obj.merge(std_attr)
                end
                 # add object
                 res.push(obj)
              end
            end

          else
            # if there is not a script, then push std_attr

            res.push(std_attr)
          end
          
        end
      end



      # close dir
      directory.close
      
      # puts "joblist:"+res.to_yaml
      
      return res
  end
  
end
