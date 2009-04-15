#!/usr/bin/env ruby

command_info="
#================================================
# SCBI - dariogf <soporte@scbi.uma.es>
#------------------------------------------------
#
# Version: 0.1 - 04/2009
#
# Usage: params2sq <template_config.conf> <params_file.json> [-with_comments]
#
# Removes empty sequences from a fasta file
#
# Prints to stdout, can be redirected to file with >
#
#================================================
\n";

require 'utils/json_utils';

include JsonUtils;

PARAMS_FILE_NAME = 'sq.conf';

#receive one argument or fail
if (ARGV.length < 2) or ARGV.length > 3
  puts command_info;
  Process.exit(-1);
end

#get params
template_file=ARGV[0];
file_name=ARGV[1]
with_comments = ARGV[2];

#check if file exists
if !File.exist?(template_file)
  puts "File #{template_file} not found.\n";
  puts command_info;
  Process.exit(-1);
end


#check if file exists
if !File.exist?(file_name)
  puts "File #{file_name} not found.\n";
  puts command_info;
  Process.exit(-1);
end

######################################
# CODE
######################################

# read input params from json file
input_params=JsonUtils::get_json_data(file_name)
                    
# create output file
output_file = File.new(PARAMS_FILE_NAME,'w')


# read template file
template = File.open(template_file).each do |line|
  
  # it is a comment
  if !line.match(/^(\s*#)/).nil?
    if with_comments
      output_file.puts line
    end
    
  elsif !(m=line.match(/\s*(\w+)\s*=\s*(\w*)\s*/)).nil?
    
    # value is one from input_params or default one
    value = input_params[m[1]+'_field'] ||= m[2]
    
    # print found value
    if !value.nil?
      output_file.puts m[1]+'='+value
    end
    
  end  
end

# close file
output_file.close;

