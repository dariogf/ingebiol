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
	   
#    puts "PARAMS:"+params.to_json
#    puts session.to_json
    @command_id = params[:command_id]
    @file_id = params[:file_id]
    @job_id = params[:job_id]
    @file_type = params[:file_type] ||='file'
     
    # print "descargando @id:" + @id
        
    if @file_id    
  	    file_to_send = File.join(DATA_PATH, @command_id, session[:user_email], @job_id, @file_id)
	  else
	      file_to_send = File.join(DATA_PATH, @command_id, session[:user_email], @job_id)
		end
        
    if File.exists?(file_to_send)
    
      if @file_type.upcase == 'IMAGE'
      
            send_file file_to_send, :type => 'image/png', :disposition => 'inline'
      else
      
				  if !File.directory?(file_to_send)
				  # send_file('/Volumes/Documentos/Progs/ruby/gui/public/images/iconAMSin.png')
					  send_file(file_to_send)
					else
							 # comprimir al vuelo y mandar
								io = self.class.make_zip_io(file_to_send)
								send_data(io.read, :filename => File.basename(file_to_send)+'.zip', :type => 'application/zip')
					  
				  end
			end

    end
    
  end

  
end
