class UiRadio < UiEditObject
  
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
    j = ''
    
    
    if @values.class == Hash
      
      @values.keys.each do |text|
         res += j
         
         if @values[text] == @default_value
           res += 'radio_button_tag("'+field_name + '","'+@values[text]+'",true)'
         else
           res += 'radio_button_tag("'+field_name + '","'+@values[text]+'")'
         end

         # add text at rigth
         res +=' + "'+text+' <br>" '
         
         j='+'
      end
      
      # pass hash of parameters as a string
      
    elsif @values.class == String
      select_values=''
      
      # puts "Read from file, but inside a model, not view:"
    end
    
    
    puts "res:"+res
        
    return res
    
  end
  
  
  
  
end
