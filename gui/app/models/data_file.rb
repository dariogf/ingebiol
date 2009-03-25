class DataFile  < BaseFileModel

  def initialize(args)
    
  end
    
  def self.save(file_object,current_command,email,id,save_as)
                                       
    if save_as!=''
       name = save_as
    else
       name = file_object.original_filename
    end
    
    # .original_filename
    
    # puts "name : ", name, ", class:",upload['filename'].class.to_s
    
    # puts "orig name : ", upload[:filename].original_filename
    
    path = File.join(DATA_PATH,current_command,email,id,name)
    
    FileUtils.mkdir_p(File.dirname(path)) unless File.exists?(File.dirname(path))
    
    File.open(path,"wb") { |f| f.write(file_object.read)}
    
  end
  

end