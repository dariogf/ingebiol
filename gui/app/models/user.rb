class User
   
  EMAIL_PATTERN = /(\S+)@(\S+)\.(\w+)/
  
  def initialize(login_params)
    
    # puts "parametros:", login_params[:email]
    
    # get params from html form
    @email = login_params[:email]
    @password = login_params[:password] ||= ''
    
  end
  
  #check if a user is valid with password agains a LDAP server
  def valid_user?
    res = false
    
    if (@email!='') and (@password!='')
      ldap= Net::LDAP.new
      ldap.host = LDAP_HOST
      ldap.auth("#{LDAP_USERS_UID}" % @email, @password)
      res = ldap.bind
    end
    
    
    return res
  end
    
  def valid_email?
    
    email_parts = @email.match(EMAIL_PATTERN)
    
    # puts "email parts", email_parts.to_s
        
    if (email_parts != nil) and (email_parts[1] != '') and (email_parts[2] != '') and (email_parts[3] != '')
      return true 
    else
      return false
    end
    
  end
  
  def get_email
    return @email
  end
  
end