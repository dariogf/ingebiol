class UiFilePopup < UiEditObject

	attr :save_as

  def initialize(command_param)
    super
    
    @save_as = command_param['save_as']
    @values = command_param['values']
  end
    
  #-----------------------------------------
  # 
  #-----------------------------------------
  def field_tag
        
    res = ''
    
    # add field
    # res = 'text_field_tag("'+field_name+'", "'+default_value+'")'
    res += 'file_field_tag("'+field_name+'", :id => "'+field_name+'")'


    
    res += ' + "   "+ '
    
    
    if @values.class == String
      #select_values='options_for_select("")'
      #
#      cmd=eval "%Q{"+@values+"}"
#      #puts cmd
#      begin
#	      val = IO.popen(cmd).readlines
#	    rescue
#	    	val = ''
#	    end
	    
	    cmd=eval @values
	    

	    
	    val =[]
	    val.push ''
	    
	    
	    Dir.glob(File.join(cmd,'**','*')) do |f|
	        if !File.directory?(f)
	      		val.push  f.gsub(File.join(cmd,''),'')
  	    	end
	    end
	    
	    #puts "List:"+cmd + val.to_json	    
	    
	    val = 'YAML.load("'+val.to_yaml+'")'
	    
      select_values='options_for_select('+val+')'
      # puts "Read from file, but inside a model, not view:"
    end
    
    
  #  val =['','uno','dos','tres']
#    val = 'YAML.load("'+val.to_yaml+'")'
#	    
#    select_values='options_for_select('+val+')'
      # puts "Read from file, but inside a model, not view:"
    
    
    res += 'select_tag("'+field_name + '_P",'+select_values+')'
    
        # add delete button if it is a not required file
    if not @required
      #res += ' + '
      res += ' + "  "+ '
      img = 'image_tag("borrar.png", {:alt => "Delete file", :border => "0" })'
      #img = '"&nbsp;reset&nbsp;"'
      res += 'link_to('+img+', "javascript:wipeField(\''+field_name+'\');")'
    end
    
    return res

  end
  
  def field_value(web_params)
    
      value = web_params[field_name+'_P']
      
      if value.blank?
	      value = web_params[field_name]
                 
  	    # if it is a field
  	    if (!value.nil?) and (value.class != String)
  	       value = value.original_filename
  	    end
  	  else
  	  	 value = File.join(PRIVATE_DATA_PATH,value);
  	  end
  	  
  	 # puts "VALUE: " + value
      
      return value
  end
   
  def save_value(web_params,current_command,user_id,job_id)

    # get popup value
    value = value = web_params[field_name+'_P']
    
    #if popup is empty, then get value from file field
    if value.blank?
	    value=web_params[field_name]
	  else
  	  value = File.join(PRIVATE_DATA_PATH,value);
	  end
	 
	  #puts "saving file: #{value}"
	 
    # if it is a field
    if (!value.nil?) #and (value.class != String)
       file = DataFile.save(value,current_command,user_id,job_id,@save_as)       
    end
    
  end
  
  def command_switch(field_value)
    res = field_value ||= ''
    #res = (@command_switch % field_value) if field_value and @command_switch
    return res
  end
  
  
end
