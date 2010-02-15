class UiCheckbox < UiEditObject
  
  def initialize(command_param)
    super
    
  end
  
  #-----------------------------------------
  # 
  #-----------------------------------------
  def field_tag
    if default_value == false
      res = 'check_box_tag("'+field_name+'", "true",false )'
    else
      res = 'check_box_tag("'+field_name+'", "true",true )'
    end
    
    # res = 'text_field_tag("'+field_name+'", @default_value)'
    
    return res
  end
  
end