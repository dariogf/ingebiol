class DownloadsController < ApplicationController
  
def self.make_zip_io(file_path)
  dir = File.dirname(file_path)
  file = File.basename(file_path)
  cmd = "bash -c 'cd #{dir}; zip -r - #{file}'"
  IO.popen(cmd)
end

  
  #-----------------------------------------
  # download a file
  #-----------------------------------------
  def download
    @id = params[:id]
              
    # print "descargando @id:" + @id
        
    file_to_send = File.join(DATA_PATH, session[:current_command], session[:user_email], session[:current_job_id], @id)
    
    
    if File.exists?(file_to_send)
    
      if !File.directory?(file_to_send)
      # send_file('/Volumes/Documentos/Progs/ruby/gui/public/images/iconAMSin.png')
	      send_file(file_to_send)
	    else
	    		 # comprimir al vuelo y mandar
					  io = self.class.make_zip_io(file_to_send)
  					send_data(io.read, :filename => File.basename(file_to_send)+'.zip', :type => 'application/zip')
	      
      end
      #,:filename => 'pepe'
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
  
 
 
  
  #-----------------------------------------
  # download a file
  #-----------------------------------------
  def download_img
    @id = params[:id]
              
    # print "descargando @id:" + @id
        
    file_to_send = File.join(DATA_PATH, session[:current_command], session[:user_email], session[:current_job_id], @id)
    
    
    if File.exists?(file_to_send)
      #send_data(file_to_send,{:type=>'img/png'})
      send_file file_to_send, :type => 'image/png', :disposition => 'inline'
    else
    end
    
    
    
  end
  
end
