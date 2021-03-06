# This is a factory pattern

class UiFactory
  
  # def initialize(args)
  #     
  # end
  #

  #-----------------------------------------
  # Create a new object based on tye input type
  #-----------------------------------------
  def self.new_ui(command_param)
    case command_param['input_type']
      
    when 'separator'
      return UiSeparator.new(command_param)
 
    when 'file'
      return UiFile.new(command_param)
    
    when 'text'
      return UiText.new(command_param)
      
    when 'integer'
      return UiInteger.new(command_param)
      
    when 'float'
      return UiFloat.new(command_param)
      
    when 'popup'
      return UiPopup.new(command_param)
    when 'file_popup'
      return UiFilePopup.new(command_param)
    when 'checkbox'
      return UiCheckbox.new(command_param)

    when 'radio'
      return UiRadio.new(command_param)
    end
  end
  
  #-----------------------------------------
  # Create objects for all input params
  #-----------------------------------------
  def self.create_objects(stage_params)
    
    res = {}
    
    # get common params for stage
    res['title']=stage_params['title'] ||= 'TITLE'
    res['stage_type']=stage_params['stage_type'] ||= 'submit'
    res['enabled']=stage_params['enabled'] ||= true
    res['submit_button_title']=stage_params['submit_button_title'] ||= 'Send'
    res['command_list']=stage_params['command_list'] ||= []
    res['next_stage_flow']=stage_params['next_stage_flow'] ||= {}
    res['use_queue_system']=stage_params['use_queue_system'] ||= false
    res['user_presets']=stage_params['user_presets'] ||= false
    res['sudo_command']=stage_params['sudo_command'] ||= QSUB_SUDO
    res['submit_command']=stage_params['submit_command'] ||= QSUB_CMD
    res['submit_file_header']=stage_params['submit_file_header'] ||= nil
    
    
    # get input params
    elems = []
    stage_params['input_params'].each do |p|

      # create elem
      elem = new_ui(p)
       
      # push it to array
      if elem 
        elems << elem
      end
    end
    
    res['input_params'] = elems
     
     return res
  end
  
end
