<% form_for :upload, :url => {:controller => 'jobs', :action => 'upload_stage'}, :html => {:multipart => true, :target => :upload_target} do |f| %>
                                             
<%= add_fields_for_params(f,@command.input_params_for_stage(session[:current_stage],,@command.submit_button_title(session[:current_stage))) %>

<%= add_form_submit_row %>

<% end %>
...............

<script>
	function openpopup(){
		var popurl="http://site.com/page.htm"
		winpops=window.open(popurl,"","width=390,height=490,scrollbars,")
  }

	openpopup();
</script>

----------

<script type="text/javascript">
	var hb1 = new HelpBalloon({
		title: 'Non-Ajax Balloon',
		content: 'This is an example of static '
			+ 'balloon content.',
		autoHideTimeout: 2000
	});
</script>




<% form_for :upload, :url => {:controller => 'jobs', :action => 'upload_file'}, :html => {:multipart => true} do |f| %>
file:
<%= f.file_field :filename %>

<%= submit_tag "upload" %>
<div id="uploadInfo"></div>
<% end %>

-----------------

<% form_for :upload, :url => {:controller => 'jobs', :action => 'upload_file'}, { :multipart => true } do |f| %>

-------------------


<div id="rjs-testbed"><%= render :partial => 'test_partial' %></div>
<%= link_to_remote "pinchar", :url => {:controller => "gui", :action => "test_rjs" } %>

<div id="otro"><%= render :partial => 'test_partial2' %></div>
<%= link_to_remote "pinchar", :url => {:controller => "gui", :action => "get_value" }, :update => 'otro', :position => :bottom %>


de login.
<% remote_form_for :sessions , :url => {:controller => 'sessions', :action => 'create'} ,:update => 'InvalidEmail', :position=> :before do |f| %>


	<!-- row de titulo -->
  <tr id="titulo1">
		<td>




---------
def add_item
  Item.create(params[:item])
  @items = Item.find(:all)
  render :update do |page|
    # Think "inline RJS"
    page[:item_list].reload
  end
end





-
<!-- row de titulo -->
<tr id="titulo1">
	<td>
	
	
		</td>
	</tr> <!-- fin row de titulo -->

----------

<!-- row de titulo -->
<tr id="titulo2" style="display: none;">
	<td>
    <!-- tabla de titulo -->
    <table width="100%" border="0" cellspacing="0" class="rowTitulo2">
    	<tr>
    		<!-- celda separadora izquierda -->
    		<td class="separadorV">&nbsp;</td>

    		<!-- celda de titulo -->
		
        <td class="tituloGrande">CAP3 WEB<span id="versionText2"></span> <span class="tituloPequeno">&nbsp;|&nbsp;A WEB INTERFACE FOR CAP3</span></td>
    	  <td>
    			<%= image_tag "amicon.png" , {:alt => "AM-icon"}%>
			                                                  
    		</td>
		
    		<td>
    			<%= image_tag "logoscbi.png", {:alt => "Logoscbi"} %>
    		</td>
    	</tr>
    </table> <!-- fin tabla titulo -->
	</td>
</tr> <!-- fin row de titulo -->

-------------


<td class="tituloGrande"><%= @command.title %><span id="versionText2"></span> <span class="tituloPequeno">&nbsp;|&nbsp;<%= @command.short_description %></span></td>

---------------
<% remote_form_for :sessions, :url => {:controller => 'sessions', :action => 'create'} ,:update => 'mainDIV', :failure => "$('InvalidEmail').update('Invalid email');" do |f| %>






-------------------


<% if !@command.input_params_stage1.blank? %>
  <% for item in @command.input_params_stage1 %>

			<% if item['input_type']=='separator' %>
					<tr>
            <td>&nbsp;</td>                          
            <td>&nbsp;</td>
          </tr>
			<% else %>
				  <tr><td>
					<!-- <font color="#8B2627"> -->
					<%= item['title'] %>
					<% if item['required'] %>
						&nbsp;*&nbsp;          
						
					<% end %>
			
					:</td><td>

					<% if item['input_type'] == 'file' %>
						 <%= f.file_field item['id'] %>                                                     
						<% if !item['required'] %>
							 <%= image_tag "borrar.png", {:alt => "Delete file" }%>															
						<% end %>
						

					<% end %>

					<% if item['input_type'] == 'text' %>
						 <%= f.text_field item['id'] %>
					<% end %>
					</td></tr>
			<% end %>                        

  <% end %>
<% else %>

<% end %>
