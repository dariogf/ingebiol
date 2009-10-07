
class JoblistsController < ApplicationController
  
  #-----------------------------------------
  # 
  #-----------------------------------------
  def get_joblist
    
    # get paths
    data_path = File.join(DATA_PATH,session[:current_command],session[:user_email])
    script_path = File.join(USER_SCRIPTS_PATH,GET_JOBINFO_SCRIPT)
    titles_path = File.join(USER_SCRIPTS_PATH,JOBLIST_TITLES_JSON)
    
    puts "Data PATH:" + data_path
    
    # Populate joblist
    @joblist = Joblist.new(data_path,script_path,titles_path)
    
  end
    
end
