$(function(){

	var form = $('#login-register');
	form.on('submit', function(e){

		if(form.is('.loading, .loggedIn')){
			return false;
		}
		var messageHolder = form.find('span');

		e.preventDefault();

		$.ajax({
					   type: "POST",
					   url: this.action,
					   data: form.serialize(),
					   dataType: 'json',
					   success: function(m){
			if(m.error){
				form.addClass('error');
	
				//displayMessage(m.message,'errorMessage');
				messageHolder.text(m.message);	
			}
			else{
				if(m.success){//login success
					location.href='QBoard/';	
				}
				
				form.removeClass('error').addClass('loggedIn');
			 	//displayMessage(m.message,'successMessage');
				messageHolder.text(m.message);
			}
		  }
		});

	});

	$(document).ajaxStart(function(){
		form.addClass('loading');
	});

	$(document).ajaxComplete(function(){
		form.removeClass('loading');
	});
	
	
});

