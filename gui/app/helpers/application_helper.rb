# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  #--------------------------------------------------------------
  # Override periocally_call_remote so we can stop/start it later
  #--------------------------------------------------------------
  def periodically_call_remote(options = {})
      variable = options[:variable] ||= 'poller'
      frequency = options[:frequency] ||= 10
      code = "#{variable} = new PeriodicalExecuter(function() 
  {#{remote_function(options)}}, #{frequency})"
      javascript_tag(code)
  end

  
  #-----------------------------------------
  # Add a separator to the page
  #-----------------------------------------
  def add_row_separator
    "<!-- row separador -->"
    '<tr class="separadorH"><td></td></tr>'
  end
                          
  #-----------------------------------------
  # add fields defined by params to the form
  #-----------------------------------------
  def add_fields_for_params(command_params,submit_button_title)
            
    res =''  
    
    using_required_fields = false
    
    if !command_params.blank?
      command_params.each do  |ui_param|
        

        
        if ui_param.is_separator then

          
          if ui_param.title!=''
            res +='<tr class="fields_small_separator">'
            res += '<td>&nbsp;</td>'
            res += '<td></td>'
            res += '<td></td>'
            res += '<td></td>'
            res += '</tr>'
            
            res +='<tr class="fields_title_separator">'
            # is a separator with title
            # res += '<td>&nbsp;</td>'     
            # res += '<td>&nbsp;</td>'
            res += '<td colspan="4" >'+ ui_param.label_tag+'</td>'
            # res += '<td>&nbsp;</td>'
            res += '</tr>'
            
          else
            # does not have title
            res +='<tr class="fields_separator">'
            res += '<td>&nbsp;</td>'
            res += '<td>&nbsp;</td>'
            res += '<td>&nbsp;</td>'
            res += '<td>&nbsp;</td>'
            res += '</tr>'
          end

        else # it is not a separator
          res +='<tr class="fields_row">'
          # add tooltip
          tooltip_text = ui_param.tooltip_tag
    
          if (tooltip_text!='')
             res += '<td>'+ image_tag("help.gif",:onmouseover=>"Tip('"+tooltip_text+"')", :onmouseout=>"UnTip()")+'&nbsp;</td>'
          else
             res += '<td>&nbsp;</td>'
          end
          
          required_class=''
          if ui_param.required
              required_class='class="requiredField"'
              using_required_fields = true
          end
        
          if ui_param.title_pos!='right'
            res += '<td><span ' + required_class + '>'
            res += ui_param.label_tag + '&nbsp:</span></td>'
          else
            res +='<td></td>'
          end
          
          # res += '<td>' + ERB.new(ui_param.field_tag).result.eval
          
          res += '<td>'
          
          res += eval(ui_param.field_tag) unless ui_param.field_tag.blank?
          
          if ui_param.title_pos=='right'
            res += '&nbsp;<span ' + required_class + '>'
            res += ui_param.label_tag + '</span>'
          end
          
          # create autocomplete on client
          if ui_param.autocomplete_values.class == Array
             # res += ' + '
             res += '<div id="'+ui_param.field_name+'_autocomplete" class="autocomplete"></div>'
             res += '<script>'
             res += 'new Autocompleter.Local("'+ui_param.field_name+'", "'+ui_param.field_name+'_autocomplete", '+array_or_string_for_javascript(ui_param.autocomplete_values)+', { });'
             res += '</script>'
          end
            
          res += '</td>'
          
          
          
          # add error message
        
          if ui_param.field_error_name!=''
            res += '<td>&nbsp&nbsp<span class="errorMessage" id="'+ui_param.field_error_name+'"></span></td>'          
          else
            res += '<td>&nbsp;</td>'
          end
          
          res +='</tr>'      
        end


        
      end 
      res += add_form_submit_row(using_required_fields,submit_button_title)      
    end    
    
    return res

  end
  
  #-----------------------------------------
  # Add a toogle bar with content inside it.
  #-----------------------------------------
  def add_toggle_row(id, title, content_partial, poller_to_control = nil)
    
    content_row_id = 'toggle_row_'+id
    
    toggle_img_id = 'toggle_img_'+id
    
    img_text= image_tag "openTriangle.png" , {:id=> toggle_img_id, :alt => "Open triangle", :border => '0'}
    
    img_text += '&nbsp;&nbsp;'+ title
    
    poller = poller_to_control ||= 'null'
    
    link_text = link_to img_text, 'javascript:miToggle(\''+content_row_id+'\',\''+toggle_img_id+'\',0.8,'+poller+');'
 

    # title row
    title_row_text='<tr id="'+id+'"><td class="menuRow">'+ link_text +'</td></tr>'
            
      
      # render content
     content_row_text = render :partial => content_partial, :locals => {:row_name => content_row_id}
              
     title_row_text+content_row_text

  end
  
  

  #-----------------------------------------
  # 
  #-----------------------------------------
  def add_form_submit_row(with_required,submit_button_title)
    res = '<tr>
        <td>&nbsp;&nbsp;</td>
			  <td>'
    
    bname = submit_button_title ||= "Send"
		
		res += '<font color="#8B2627">* Required field</font>' if with_required
		res += '&nbsp</td>
				<td style="text-align:right">'+ submit_tag(bname) + '</td>
		       </tr>'
		       
		return res
  end
  
end
