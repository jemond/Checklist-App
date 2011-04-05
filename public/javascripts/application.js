// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {
						   
	$('#SubmitAreaControls input').attr('disabled', '');
	
	$(window).bind('onunload', function() { // catch if changed
		return 'You have unsaved changes!';
	});

	$('form').submit(function(){
		$('#SubmitAreaControls input').attr('disabled', 'disabled');
		showAction('Loading');
		return true;
	});
	
	$('#CancelButton').click(function() {
		$('#SubmitAreaControls input').attr('disabled', 'disabled');
		showAction('Cancelling');
		location.href='../';
	});

	$('#ChecklistBody').keydown(function (e) {
		var dummy = $('<div id="autoSizeHolder"></div>');
		dummy.css({
			'overflow-x':'hidden',
			'display':'none',
			'position':'absolute',
			'top':0,
			'line-height': $(this).css('line-height'),
			'font-size'  : $(this).css('font-size'),
			'font-family': $(this).css('font-family'),
			'width'      : $(this).css('width'),
			'padding'    : $(this).css('padding'),
			}).appendTo('body').html(($(this).val()).replace(/\n/g, '<br>new'));
		
		if(e.keyCode == 13)
			dummy.html(dummy.html()+'<br>new');
		
		if($(this).height() != dummy.height() + parseInt($(this).css('line-height')) && dummy.height() + parseInt($(this).css('line-height')) > 150)
			$(this).css({'height':(dummy.height()+3*parseInt($(this).css('line-height')))}); // 2 extra spaces below
		else
			$(this).css({'height':150});
		
		$('#autoSizeHolder').remove();
	}).trigger('keydown'); // initial set
	
	$('#ChecklistBody').keyup(function() {
		var splitSource = $(this).val().trim().split('\n');
		var items = '';
		var title = '';
		var emails = '';
		var isEmail = false;
		
		title = (splitSource[0]) ? splitSource[0] : 'No title';
		for(i=1;i<splitSource.length;i++) {
			isEmail = false;
			if(i+1 == splitSource.length) // check if email
				if(validateEmail(splitSource[i])) // check if just one email
					isEmail = true;
				else { // check if more than 1 email and ensure all valid
					splitEmails = splitSource[i].split(',');
					isEmail = splitEmails.length == 0 ? false : true;
					for(j=0;j<splitEmails.length;j++) {
						if(!validateEmail(splitEmails[j].trim()))
							isEmail = false;
					}
				}

			// to do - fix the preg removal for #s in the item, like "post 3 records"
				
			if(isEmail)
				emails = splitSource[i];
			else if (splitSource[i].length > 0) {
				items = items + '<li>'+splitSource[i].replace(/[0-9]+[ ]?[\.]?[\-]?/,'')+'</li>';
			}
		}
		
		emails = isEmail ? '<h3>Emailing when complete: '+emails+'</h3>' : '';
			
		$('#PreviewBox').empty().html('<h2>'+title+'</h2><ol>'+items+'</ol>'+emails);
	}).trigger('keyup');
});

// to do - auto number when press enter, but can still edit number