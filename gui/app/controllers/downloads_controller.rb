class DownloadsController < ApplicationController
  
  
  #-----------------------------------------
  # download a file
  #-----------------------------------------
  def download
    @id = params[:id]
              
    # print "descargando @id:" + @id
        
    file_to_send = File.join(DATA_PATH, session[:current_command], session[:user_email], session[:current_job_id], @id)
    
    
    if File.exists?(file_to_send)
      # send_file('/Volumes/Documentos/Progs/ruby/gui/public/images/iconAMSin.png')
      send_file(file_to_send)
    else
      # print "File doesn't exists"
      #       
      #       render :update do |page|
      #          page[@id+'_div'].replace_html('Does not exists')
      #       end
      #       
    end
    
    
    
    # render :nothing => true
    
    
  end
  
end
