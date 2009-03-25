# Class for a horizontal separator

class UiSeparator < UiObject
  
  
  def initialize(command_param)
    super
    
    @is_separator = true
    
  end
  
  #-----------------------------------------
  # 
  #-----------------------------------------
  def label_tag
    return title
    
  end
  

end