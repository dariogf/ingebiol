class UiFloat < UiEditObject

  attr :validation_lower_limit
   attr :validation_upper_limit


   def initialize(command_param)
     super

     @validation_lower_limit=command_param['validation_lower_limit']
     @validation_upper_limit=command_param['validation_upper_limit']

   end


   def label_tag
     return @title + range_as_string
   end

   #-----------------------------------------
   # Returns an expression with the range, if available
   #-----------------------------------------
   def range_as_string

     res = ''

     if @validation_lower_limitor or @validation_upper_limit

       if @validation_lower_limit!='' or @validation_upper_limit!=''

         res += '&nbsp;&nbsp;&nbsp;&#x2192;&nbsp;&nbsp;'


         # have a valid lower limit
         if @validation_lower_limit!=''
            res += '[&nbsp;' + @validation_lower_limit + '&nbsp;,&nbsp;'
         else
            res += '[&nbsp;&#8722;&#8734&nbsp;,&nbsp;'
         end

         # have a valid upper limit
         if @validation_upper_limit!=''
            res += @validation_upper_limit + '&nbsp;]'
         else
            res += '&#8734&nbsp;]'
         end
       end
     end            

     return res

   end

   #-----------------------------------------
   # 
   #-----------------------------------------
   def field_tag

     if @size and (@size.to_i > 0)
       res = 'text_field_tag("'+field_name+'", "'+@default_value+'", :size => "'+@size.to_s+'")'
     else
       res = 'text_field_tag("'+field_name+'", "'+@default_value+'", :size => "6")'
     end

     return res
   end


   #-----------------------------------------
   # Validates an integer field
   #-----------------------------------------
   def validate(web_params,errors)

     field_value = web_params[field_name]

     if super
       # check if it is an integer
       if (field_value.match(/^-?\d+\.?\d*$/).to_s=='')
         errors[field_name] = 'Please, provide a valid number'

       else #is a number

         # check limits
         n = field_value.to_f

         if @validation_lower_limit and @validation_lower_limit!=''
            if n<@validation_lower_limit.to_f
              errors[field_name] = 'Value must be greater than '+@validation_lower_limit
            end
         end

         if @validation_upper_limit and @validation_upper_limit!=''
            if n>@validation_upper_limit.to_f
              errors[field_name] = 'Value must be lower than '+@validation_upper_limit
            end
         end

       end
     end

   end
  
  
end