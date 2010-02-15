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
	   
    puts "PARAMS:"+params.to_json
    
    @command_id = params[:command_id]
    @file_id = params[:id]
    @job_id = params[:job_id]
              
    # print "descargando @id:" + @id
        
    file_to_send = File.join(DATA_PATH, @command_id, @user, @job_id, @file_id)
    
    
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
  # download a complete job
  #-----------------------------------------
  def download_job
    @command_id = params[:command_id]
    @file_id = params[:id]
    @job_id = params[:job_id]
              
    # print "descargando @id:" + @id
        
    file_to_send = File.join(DATA_PATH, @command_id, @user, @job_id)
    

              
    # print "descargando @id:" + @id
        
#    file_to_send = File.join(DATA_PATH, session[:current_command], session[:user_email], @job_id)
        
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
    @command_id = params[:command_id]
    @file_id = params[:id]
    @job_id = params[:job_id]
    @user = session[:user_email]
    
    puts @command_id + ', '+  @user+ ', '+  @job_id+ ', '+  @file_id
    # print "descargando @id:" + @id
        
    file_to_send = File.join(DATA_PATH, @command_id, @user, @job_id, @file_id)

	  puts "file: "   + file_to_send

    # print "descargando @id:" + @id
        
    #file_to_send = File.join(DATA_PATH, session[:current_command], session[:user_email], session[:current_job_id], @id)
    
    
    if File.exists?(file_to_send)
      #puts "enviar"
      #send_data(file_to_send,{:type=>'img/png'})
      send_file file_to_send, :type => 'image/png', :disposition => 'inline'
    else
      #send_data(nil,{:type=>'img/png'})
    end    
  end
  
end
