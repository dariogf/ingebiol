#================================================
# SCBI - dariogf <soporte@scbi.uma.es>
#------------------------------------------------
#
# Version: 0.1 - 04/2009
#
# Usage: require "utils/fasta_utils"
#
# Fasta utilities
#
# 
#
#================================================

module FastaUtils
  
  
  #########################################
  # Reads a fasta file and fires events to
  # process it.
  #########################################
  class FastaReader
    
    #------------------------------------
    # Initialize instance
    #------------------------------------
    def initialize(file_name)
      if File.exist?(file_name)
        on_begin_process();
        
        scan_file(file_name);
        
        on_end_process();
        
      end
    end
    
    #------------------------------------
    # Scans a file, firing events to process content
    #------------------------------------
    def scan_file(file_name)
      
      #init variables
      seq_name = '';
      seq_fasta = '';
      seq_found = false;
    
      
      # for each line of the file
      File.open(file_name).each do |line|
        
        line.chomp!;
        # if line is name
        if line =~ /^>/
          
          #process previous sequence
          if seq_found
            on_process_sequence(seq_name,seq_fasta);
          end
          
          #get only name
          seq_name = line.gsub('>','');
          seq_fasta='';
          seq_found = true;
          
        else
          #add line to fasta of seq
          seq_fasta+=line;
        end
          
      end
    
      # when found EOF, process last sequence
      if seq_found
        on_process_sequence(seq_name,seq_fasta);
      end
          
    end
    
    #------------------------------------
    # Event fired when process is going to begin
    #------------------------------------
    def on_begin_process()
      # subclasses may override this method        
    end
    
    #------------------------------------
    # Event fired when a new sequence is found
    #------------------------------------
    def on_process_sequence(seq_name,seq_fasta)
      # subclasses may override this method
    end
    
    #------------------------------------
    # Event fired when process is going to end
    #------------------------------------
    def on_end_process()
      # subclasses may override this method
    end
    
  end
  
end
