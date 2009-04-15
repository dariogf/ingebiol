#!/usr/bin/env ruby

# This file exports custom data for joblist table

# param1 
                
require 'json'

job_folder = $*[0]

size_command = 'du -sh '+job_folder+' | cut -f 1'

job_size = `#{size_command}`
job_size = job_size.chomp

# empty hash
res = {}

# define fields
res['job_finished'] = job_size
# res['other_field'] = 'value'


# return results to json format
puts res.to_pretty_json
