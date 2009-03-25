class UiObject

  # declare accesors
  attr :type
  attr :id
  attr :title
  attr :default_value
  attr :required
  attr :tooltip
  attr :standard_attribute
# attr :command_switch
  attr :size 


  attr :required_error_msg
  attr :title_pos
  
  attr :is_separator
  attr :save_in_presets
  attr :autocomplete_values
  
  def initialize(command_param)
    
    # extract params
    @type=command_param['input_type']
    @id=''
    @title=''
    @title=command_param['title'] ||= ''
    @default_value=''
    @required=false
    @tooltip=''
    @standard_attribute=false
    @is_separator = false 
    @command_switch = ''
    @size = '0'
    @title_pos='left'
    
    @required_error_msg=''
    
    @save_in_presets = command_param['required_error_msg'] ||= false
    @autocomplete_values = command_param['autocomplete_values'] ||= nil
    

    
    # It is a string, so it may be a file with content
    if (@autocomplete_values) and (@autocomplete_values.class==String)
      # puts "it is a string"
      
      if File.exists?(File.join(COMMAND_CONFIG,@autocomplete_values))
        # puts "file exists"
        # read
        @autocomplete_values=BaseFileModel.get_json_data(File.join(COMMAND_CONFIG,@autocomplete_values))
        # clear if it is not an array
        if @autocomplete_values.class != Array then
          # puts "file is not array:"+@autocomplete_values.class.to_s + ';'+ @autocomplete_values
          @autocomplete_values=nil

        else
          # puts "new auto:"+@autocomplete_values.entries.join('-----')
        end
      end
      
    
    end
    
  end
  
  #-----------------------------------------
  # 
  #-----------------------------------------
  def field_switch
    return ''
  end
  
  def field_name
    return ''
  end
  
  def field_error_name
    return ''
  end
     
  #-----------------------------------------
  # 
  #-----------------------------------------
  def tooltip_tag
    return ''
  end
  
  #-----------------------------------------
  # 
  #-----------------------------------------
  def field_tag
    return ''
  end
  
  #-----------------------------------------
  # 
  #-----------------------------------------
  def label_tag
    return ''
  end
   
  #-----------------------------------------
  # Validates a text field
  #-----------------------------------------
  def validate(web_params,errors)
     return true
  end
  
  def command_switch(field_value)
      return ''
  end
  
  def field_value(web_params)
      return ''
  end
  
  def save_value(web_params,current_command,user_id,job_id)
  
  end
   
  #-----------------------------------------
  # 
  #-----------------------------------------
  def save_field_value(web_params,std_attrs)
        
  end
 
 
end