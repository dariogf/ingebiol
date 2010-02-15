class CommandsController < ApplicationController
  
  def index

  	cmd = Command.new(params[:id])
  	@programs = cmd.list_programs
  	
  end

end
