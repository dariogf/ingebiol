class UiPopup < UiEditObject
  
  attr :values

  def initialize(command_param)
    super
    
    @values = command_param['values']
  end
  
  #-----------------------------------------
  # 
  #-----------------------------------------
  def field_tag
        
    res = ''
        
    if @values.class == Hash
      
      # pass hash of parameters as a string
      val = 'YAML.load("'+@values.to_yaml+'")'
      
      if @default_value!= ''
        select_values = 'options_for_select('+val+',"'+@default_value+'")'
      else
      
        select_values = 'options_for_select('+val+')'
      end
      
    elsif @values.class == String
      #select_values='options_for_select("")'
      
      cmd=eval "%Q{"+@values+"}"
      #puts cmd
      begin
	      val = IO.popen(cmd).readlines
	    rescue
	    	val = ''
	    end
	    
	    val = 'YAML.load("'+val.to_yaml+'")'
	    
      select_values='options_for_select('+val+')'
      # puts "Read from file, but inside a model, not view:"
    end
    
    
    res += 'select_tag("'+field_name + '",'+select_values+')'
    
    #puts "res:"+res
        
    return res
    
  end
  
end
