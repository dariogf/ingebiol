class UiText < UiEditObject
  attr :validation_regex
  attr :validation_error_msg
  
  def initialize(command_param)
    super
    
    # load params
    @validation_regex = command_param['validation_regex']
  	@validation_error_msg = command_param['validation_error_msg']
    
  end
  
  #-----------------------------------------
  # Validates a text field
  #-----------------------------------------
  def validate(web_params,errors)
    
    if super
      value = field_value(web_params)
      
      # requires validation
      if @validation_regex and @validation_regex!=''
        # does not match
        if (value.match(@validation_regex).to_s=='')
          errors[field_name] = @validation_error_msg
        end
      end
      
    end
  end
  
  #-----------------------------------------
  # 
  #-----------------------------------------
  def field_tag
    if size and (size.to_i > 0)
      res = 'text_field_tag("'+field_name+'", "'+default_value+'", :size => "'+size.to_s+'")'
    else
      res = 'text_field_tag("'+field_name+'", "'+default_value+'")'
    end
    
    
    # res = 'text_field_tag("'+field_name+'", @default_value)'
    
    return res
  end
  
  
end