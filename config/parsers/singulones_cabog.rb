#!/usr/bin/env ruby

# Rocio & Noe
# 30 Sept 2009


$seq={}
def array_con_nombres
	array_names=[]
	fasta=''
	name=nil
	File.open("fasta.pname").each_line do |line|
		if(line=~ /^>([\w\-\_]+)\s/)
			if(!name.nil?)
				$seq[name]=fasta
			end
			name=$1
			array_names.push name
			fasta=''
		else
			fasta += line
			# puts fasta
		end
	end
	if(!name.nil?)
		$seq[name]=fasta
	end
	return(array_names)
end

def create_sing_file_with_names(nombres)
	outputfile = File.new("all_singletons.fasta", "w")
	File.open("9-terminator/pname.singleton.fasta").each_line do |line|
		if(line=~/^>(\d\d*)\s/)
			number=(($1.to_i)-(2))
			outputfile.puts ">"+nombres[number.to_i]
		else
			outputfile.puts line
		end
	end
	File.open("pname.singletons").each_line do |line|
			line.chomp!
			outputfile.puts ">"+line+"\n"
			outputfile.puts $seq[line]
	end
end

$qual={}
def array_qual_con_nombres
	array_qual_names=[]
	qual=''
	name=nil
	File.open("qual.pname").each_line do |line|
		if(line=~ /^>([\w\-\_]+)\s/)
			if(!name.nil?)
				$qual[name]=qual
			end
			name=$1
			array_qual_names.push name
			qual=''
		else
			qual += line
			# puts qual
		end
	end
	if(!name.nil?)
		$qual[name]=qual
	end
	return(array_qual_names)
end

def create_sing_qual_file_with_names(nombres)
	outputfile = File.new("all_singletons.qual", "w")
	File.open("9-terminator/pname.singleton.fasta").each_line do |line|
		if(line=~/^>(\d\d*)\s/)
			number=(($1.to_i)-(2))
			outputfile.puts ">"+nombres[number.to_i]
			outputfile.puts $qual[nombres[number.to_i]]
		end
	end
	File.open("pname.singletons").each_line do |line|
			line.chomp!
			outputfile.puts ">"+line+"\n"
			outputfile.puts $qual[line]
	end
end



#ejecutamos una funcion que recorre el fichero fasta y guarda los nombres de las secuencias en un array
array_nombres=array_con_nombres
create_sing_file_with_names(array_nombres)

array_qual_nombres=array_qual_con_nombres
create_sing_qual_file_with_names(array_qual_nombres)

