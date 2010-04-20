class UiEditObject < UiObject

  # declare accesors

  # attr :id
  # attr :title
  # attr :default_value
  # attr :required
  # attr :tooltip
  # attr :standard_attribute
  # attr :command_switch
  # attr :size
  
  def initialize(command_param)
    super
    
    # extract params

    @id=command_param['id'] 
    @title=command_param['title']
    @default_value=command_param['default_value']
    @required=command_param['required']
    @tooltip=command_param['tooltip'] 
    @standard_attribute=command_param['standard_attribute']
    @size = command_param['size']
    @command_switch = command_param['command_switch']

    @title_pos=command_param['title_pos'] ||= 'left'
    @required_error_msg=command_param['required_error_msg'] ||= ''
    
  end
  
  #-----------------------------------------
  # 
  #-----------------------------------------
  def is_separator
    return false
  end
  
  #-----------------------------------------
  # 
  #-----------------------------------------
  # def validate(web_params,errors)
  # 
  #   
  # end
  
  #-----------------------------------------
  # 
  #-----------------------------------------
  def validate(web_params,errors)

    res = true
    
    value = field_value(web_params)
    
    # if !value.nil?
    #       puts "required value:"+id+'-'+value+'-'
    # end
    
    if @required 		  
		  if (value == '' or value.nil?)
		    if @required_error_msg != ''
		      errors[field_name] = @required_error_msg
		    else
		      errors[field_name] = 'This is a required field'
		    end
		    
		    res = false
		  end
   end
    
    return res
  end
  
  #-----------------------------------------
  # 
  #-----------------------------------------
  def field_switch
    return '$'+id
  end
  
  def field_name
    return id + '_field'
  end
  
  def field_error_name
    return id + '_field_error'
  end
  
  #-----------------------------------------
  # 
  #-----------------------------------------
  def tooltip_tag
    res =''
    res = @tooltip
    res += '. This is a required field.' if @tooltip and @required
    
    return res
  end
  
  #-----------------------------------------
  # 
  #-----------------------------------------
  def field_tag
    res =''
    
    return res
  end
  
  #-----------------------------------------
  # 
  #-----------------------------------------
  def label_tag
    res =@title
    
    return res
  end
   
  def command_switch(field_value)
    res = ''
    res = (@command_switch % field_value) if !field_value.blank? and @command_switch
    return res
  end
 
  def field_value(web_params)
    
      value = web_params[field_name]
      
      return value
  end
     
  #-----------------------------------------
  # 
  #-----------------------------------------
  def save_field_value(web_params,std_attrs)

    std_attrs[field_name]=field_value(web_params)
        
  end
  
  
end
