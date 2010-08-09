class DataFile  < BaseFileModel

  def initialize(args)
    
  end
    
  def self.save(input_file,current_command,email,id,save_as)
    
    
    # is a file object
    if (!input_file.nil?) and (input_file.class != String)
    
    	file_object = input_file
    	
	    if save_as!=''
  	     name = save_as
  	  else
  	     name = file_object.original_filename
  	  end
  	  
  	else # is a path object
  	
  	  file_object = File.open(input_file,'rb')
  	  
	    if save_as!=''
  	     name = save_as
  	  else
  	     name = File.basename(input_file)
  	  end
  	
  	end
    
    path = File.join(DATA_PATH,current_command,email,id,name)    
    
    puts "SAVE_DATA: #{file_object.path} to #{path}"
    
    
    FileUtils.mkdir_p(File.dirname(path)) unless File.exists?(File.dirname(path))
    
    File.open(path,"wb") { |f| f.write(file_object.read) }

    file_object.close
    
  end
  
  def self.copy(file_path,current_command,email,id,save_as)
  

  end
  

end
