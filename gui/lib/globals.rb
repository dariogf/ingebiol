#BASE_PATH = '/Volumes/Documentos/Progs/ruby/gui'
#BASE_PATH = '/export/home_users/home/soft/bioperl/rails/gui'
BASE_PATH = './'

CONFIG_PATH = '../config'

require "#{CONFIG_PATH}/global/globals.rb"
require "#{CONFIG_PATH}/global/queue_system.rb"
require "#{CONFIG_PATH}/global/ldap.rb"



# QSUB_CMD = 'mate '

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
