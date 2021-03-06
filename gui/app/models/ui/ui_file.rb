class UiFile < UiEditObject

	attr :save_as

  def initialize(command_param)
    super
    
    @save_as = command_param['save_as']
    
  end
    
  #-----------------------------------------
  # 
  #-----------------------------------------
  def field_tag
        
    res = ''
    
    # add field
    # res = 'text_field_tag("'+field_name+'", "'+default_value+'")'
    
    res += 'file_field_tag("'+field_name+'", :id => "'+field_name+'")'

    
    # add delete button if it is a not required file
    if not @required
      res += ' + '
      img = 'image_tag("borrar.png", {:alt => "Delete file", :border => "0" })'
      #img = '"&nbsp;reset&nbsp;"'
      res += 'link_to('+img+', "javascript:wipeField(\''+field_name+'\');")'
    end
        
    return res
  end
  
  def field_value(web_params)
    
      value = web_params[field_name]
                        
      # if it is a field
      if (!value.nil?) and (value.class != String)
         value = value.original_filename
      end
      
      return value
  end
   
  def save_value(web_params,current_command,user_id,job_id)


    value = web_params[field_name]
	 
	 puts "saving file: #{value}"                                              
	 
    # if it is a field
    if (!value.nil?) and (value.class != String)
       file = DataFile.save(value,current_command,user_id,job_id,@save_as)
       
    end
    
  end
  
  def command_switch(field_value)
    res = field_value ||= ''
    #res = (@command_switch % field_value) if field_value and @command_switch
    return res
  end
  
  
end
