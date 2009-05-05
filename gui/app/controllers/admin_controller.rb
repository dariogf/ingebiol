class AdminController < ApplicationController
  def edit
    file = params[:id] ||= 'common.json'
    
    # set current data path
    current_command_path = File.join(COMMAND_CONFIG,session[:current_command],file)
    
    json_text = File.read(current_command_path)
    
    
    # wipe text
    @json_text=json_text.gsub(/#.*$/,'').gsub(/^\n$/,'')

    #grep(/^[\s]*[^#]/).to_s
    
    #responder en json
    
    #render :update do |page|
         #page<< "JSONeditor.start('tree','jform',#{json_text},true)"
         #page<< "JSONeditor.start('tree','jform',#{@json_text},true)" 
    #end
  end
end
