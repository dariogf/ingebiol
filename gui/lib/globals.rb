#BASE_PATH = '/Volumes/Documentos/Progs/ruby/gui'
#BASE_PATH = '/export/home_users/home/soft/bioperl/rails/gui'
BASE_PATH = './'

CONFIG_PATH = '../config'

require "#{CONFIG_PATH}/global/globals.rb"
require "#{CONFIG_PATH}/global/queue_system.rb"
require "#{CONFIG_PATH}/global/ldap.rb"

# ================= JSON encoding ==============
class Object
  
  #-----------------------------------------
  # 
  #-----------------------------------------
  def to_pretty_json
    return JSON.pretty_generate(self)
  end
  
end

class String
  
   #-----------------------------------------
   # 
   #-----------------------------------------
   def from_json
     return JSON.parse(self)
   end
end



# ================= Numeric ==============
class Numeric
  
  def to_exact_human
    if self!=0
      units = %w{B KB MB GB TB}
      e = (Math.log(self)/Math.log(1024)).floor
      s = "%.3f" % (to_f / 1024**e)
      s.sub(/\.?0*$/, units[e])
    else
      s = '0KB'
    end
  end
  
  def to_human
    if self!=0
      units = %w{B KB MB GB TB}
      e = (Math.log(self)/Math.log(1024)).floor
      s = "%.1f" % (to_f / 1024**e)
      s.sub(/\.?0*$/, units[e])
    else
      s = '0KB'
    end
  end
  
end

require "ostruct"

class Object
def to_openstruct
self
end
end

class Array
def to_openstruct
map{ |el| el.to_openstruct }
end
end

class Hash
def to_openstruct
mapped = {}
each{ |key,value| mapped[key] = value.to_openstruct }
OpenStruct.new(mapped)
end
end
