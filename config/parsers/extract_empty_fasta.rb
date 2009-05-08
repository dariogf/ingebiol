#!/usr/bin/env ruby

command_info="
#================================================
# SCBI - dariogf <soporte@scbi.uma.es>
#------------------------------------------------
#
# Version: 0.1 - 04/2009
#
# Usage: extract_empty_fasta.rb <fasta_file>  [> <out_file.xml>]
#
# Extract names of empty sequences from a fasta file
#
# Prints to stdout, can be redirected to file with >
#
#================================================
\n";

require File.dirname(__FILE__) + '/utils/fasta_utils';


#receive one argument or fail
if ARGV.count != 1
  puts command_info;
  Process.exit(-1);
end

#get file name
file_name=ARGV[0];

#check if file exists
if !File.exist?(file_name)
  puts "File #{file_name} not found.\n";
  puts command_info;
  Process.exit(-1);
end

######################################
# Define a subclass to override events
######################################
class FastaProcessor< FastaUtils::FastaReader

  #override begin processing
  def on_begin_process()
          
  end
 
  #override sequence processing
  def on_process_sequence(seq_name,seq_fasta)
    
    if seq_fasta.empty?
      puts "#{seq_name}";
    end
  end
  
  #override end processing
  def on_end_process()
  
  end
   
end

#Create a new instance to process the file
f=FastaProcessor.new(file_name);
