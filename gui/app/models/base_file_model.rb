class BaseFileModel
      
  #-----------------------------------------
  # Get json from a file
  #-----------------------------------------
  def get_json_data(file_path)
    file1 = File.open(file_path)
    text = file1.read
    file1.close
    
    # wipe text
    text=text.grep(/^\s*[^#]/).to_s
    
    # decode json
    data = ActiveSupport::JSON.decode(text)

    return data
  end
  #-----------------------------------------
  # Get json from a file
  #-----------------------------------------
  def self.get_json_data(file_path)
    file1 = File.open(file_path)
    text = file1.read
    file1.close
    
    # wipe text
    text=text.grep(/^\s*[^#]/).to_s
    
    # decode json
    data = ActiveSupport::JSON.decode(text)

    return data
  end
   
  
end