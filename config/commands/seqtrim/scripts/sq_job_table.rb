#!/usr/bin/env ruby

# This file exports custom data for joblist table

# param1 
                
require 'json'

job_folder = $*[0]


# create an empty hash
res = {}

# define fields in hash
res['col1']=''

# return results to json format
#puts to_pretty_json(res)

puts JSON.pretty_generate(res)

# TODO - modificar para que se puedan añadir más joblist_titles en el orden adecuado



