class CommandsController < ApplicationController
  
  def index
   
  	#cmd = Command.new(params[:id])
    #    puts "ACTUAL:"+params.to_json
  	@programs=Command.list_programs
  	@selected_cmd = params[:selected_cmd]
  	
  	
  end

end
