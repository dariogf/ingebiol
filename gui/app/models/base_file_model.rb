#require 'kwalify'

class BaseFileModel
      
  #-----------------------------------------
  # Get json from a file
  #-----------------------------------------
  def get_json_data(file_path)
   # file1 = File.open(file_path)
#    text = file1.read
#    file1.close
#    
#    # wipe text
#    #text=text.grep(/^\s*[^#]/).to_s
#    text=text.gsub(/^\s*#.*$/,'').gsub(/^\n$/,'')
#    
#    data=nil
#    # decode json
#    if !text.blank?
#	    data = ActiveSupport::JSON.decode(text)
#	  end
#    #data = JSON.parse(text)
#    return data

    return BaseFileModel.get_json_data(file_path)
  end
  #-----------------------------------------
  # Get json from a file
  #-----------------------------------------
  def self.get_json_data(file_path)
	
	  data=nil
				
	  if File.exists?(file_path)
				file1 = File.open(file_path)
				text = file1.read
				file1.close
				
				# wipe text
				#text=text.grep(/^\s*[^#]/).to_s
				text=text.gsub(/^\s*#.*$/,'').gsub(/^\n$/,'')

				# decode json
				# data = ActiveSupport::JSON.decode(text)
				# decode json
				if !text.blank?
				
				#schema = Kwalify::Yaml.load_file('schema.yaml')
				#validator = Kwalify::Validator.new(schema)
					data = ActiveSupport::JSON.decode(text)
				end
				#data = JSON.parse(text)
		end
		
    return data
  end
  
  def to_json2(id=nil)
		  return	ActiveSupport::JSON.encode(self)  
  end
   
  
end
