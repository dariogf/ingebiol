#!/usr/bin/env ruby

# This file exports custom data for joblist table

# param1 
                
require 'json'


job_folder = $*[0]

# ======== SUPPORT FUNCTIONS =========


#-----------------------------------------
# Get the size of a folder
#-----------------------------------------
def get_size(folder,hash)
  
  size_command = 'du -sh '+folder+' | cut -f 1'

  job_size = `#{size_command}`
  job_size = job_size.chomp

  hash['job_size']=job_size


end

#-----------------------------------------
# Get the ctime of a folder
#-----------------------------------------
def get_ctime(folder,hash)
  
  
  hash['job_date']=File.ctime(folder).strftime('%d/%m/%y')


end


#-----------------------------------------
# Check if job is ok
# E.g.: looking for error files
#-----------------------------------------
def job_status(folder,hash)
  
  error_files = []
  
  status = 'LOCAL'
  
  # if there is a sh file, it is a queue job
  sh_files = Dir.glob(File.join(folder,'*.sh'))
  
  #there are sh files
  if !sh_files.empty?
    #is queue job
    status = 'UNKNOWN' 
    
    if File.exists?(File.join(folder,'QUEUED'))
      status = 'QUEUED'	
      
    elsif File.exists?(File.join(folder,'RUNNING'))
      status = 'RUNNING'
    else
      error_files = []
      error_files |= Dir.glob(File.join(folder,'*.sh.e*'))
      error_files.push(File.join(folder,'ERRORS'))
      
      errors=''
      
        
        #TODO - add more files for errors
        error_files.each do |ename|
          if File.exists?(ename)
            errors += File.read(ename)
          end
        end
        
        errors.gsub!(/\n/,'<br>')
        errors.gsub!(/'/,'`')

        
        
        if errors != ''
          status = 'ERRORS'
          hash['errors']=errors
        else
          status = 'DONE'
        end
      
    end
      
    
  else
    # normal job
     
  end
  
  hash['job_status'] = status
  
end



# create an empty hash
res = {}

# define fields in hash
get_size(job_folder,res)

get_ctime(job_folder,res)


job_status(job_folder,res)

# return results to json format
#puts to_pretty_json(res)

puts JSON.pretty_generate(res)





