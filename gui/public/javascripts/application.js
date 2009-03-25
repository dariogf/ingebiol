// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function wipeField (fieldName) {
  // alert(fieldName);
  if ($(fieldName)) {
      $(fieldName).value = '';
  };

}



	function ShowText(id) {
		document.getElementById(id).style.display = 'block';
	}
	
	function HideText(id) {
		document.getElementById(id).style.display = 'none';
	}
         
         
// -----------------------

