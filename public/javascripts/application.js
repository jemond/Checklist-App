/*
 Startup routines when the dom is loaded
*/
$(document).ready(function() {
	monitorFlashNotices();
	
	// if this is the editor page, load the editor helper
	if($('#ChecklistBody'))
		startUpChecklistEditor();
		
	startUpChecklist();
});

/*
 Monitor the flash messages that appear
 - Hide them after a few seconds
 - Don't hide ones with class "persist"
*/
function monitorFlashNotices() {
	$('#Flash').each(function() {
		if(!$(this).hasClass('persist'))
			$(this).effect('fade', {}, 3000);
	});
}

/*
	The checklist editor is when you are editing the template of a checklist
	- Dynamically expand the text area as they type
	- Stylize the editor
	- Update live preview on right side
*/
function startUpChecklistEditor() {
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
		
		emails = isEmail ? '<h3 class="emails">Emailing when complete: '+emails+'</h3>' : '';
			
		$('#PreviewBox').empty().html('<h2>'+title+'</h2><ol>'+items+'</ol>'+emails);
	}).trigger('keyup');
}

/*
 BEGIN: Checklist checker
*/

function startUpChecklist() {
	$('.checkoff-link').bind('ajax:success', successfulCheckOff);
	
	$('input').bind('click', function(event) {
		// Get the task ID
		var task_id = event.currentTarget.id.split("_")[1];
		var path = getCheckOffPath(task_id);
		
		$.ajax({
			url: path,
			dataType: 'json',
			context: document.body,
			start: function() { toggleLoader(task_id) },
			stop: function() { toggleLoader(task_id) },
			success: function(data) { successfulCheckOff(data, task_id) }
		})
	});
	
	// when the finish box is clicked we replace it with the loader icon for some affordance juice
	$('.yo').bind('click',function(events) {
		$('#finishbar').toggle();
		$('#finishloader').show();
	});
	
	// flash the finish box if a new page load on a finished checklist
	updateFinished();
}

function toggleLoader(id) {
	return $('loader_'+id).toggle();
}

// when they tick it off, check it off
function successfulCheckOff(response, id) {
	// we get the instance back, and sniff the finished_items		
	var response = response.instance;
	var label = $('#label_'+id);
	var item = $('#item_'+id);
	
	// if our item id in question is in the returned finished_items, strikeout, otherwise, strikein
	if(response.finished_items.indexOf(id) >= 0) {
		label.addClass('strikeout');
		item.checked = true;
	} else {
		label.removeClass('strikeout');
		item.checked = false;
	}
	
	toggleAbandonBox(response);
	toggleEditBox();
	updateFinished();
}
// turn on the alt abandon box if this was the first checklist item
function toggleAbandonBox(response) {
	var AltAbandonBox = $('#AltAbandonBox');
	var AbandonBox = $('#AbandonBox');
	
	if( !AltAbandonBox.is(':visible') && ( AbandonBox == null || !AbandonBox.is(':visible') ) ) {
		$('#AltAbandonBox span.time_ago_in_words').each(function() {
			$(this).html(make_date_humane(response.updated_at));
		});
		AltAbandonBox.toggle().effect('highlight', {}, 2250);	
	}
}	

// hide the edit box once they get into edit mode
function toggleEditBox() {
	var EditControl = $('#EditControl');
	if(EditControl.is(':visible'))
		EditControl.hide();
}

// make sure if this was the last item we show the finish box
function updateFinished() {
	// if this is the last item, then we have show the finish control
	if(isChecklistFinished())
		$('#FinishedBlock').show().effect('highlight', {}, 2250);
	else
		$('#FinishedBlock').hide();
}

// if all items are striked-out, then it's finished
function isChecklistFinished() {
	finished = true;
	$('.itemlabel').each(function() {
		if(!$(this).hasClass('strikeout')) {
			finished = false;
			return false;
		}
	});
	
	return finished;
}

/*
 END: Checklist checker
*/


/*
// to do - auto number when press enter, but can still edit number
*/

// http://blog.mythin.net/projects/jquery.php
/*
$.fn.pause = function(milli,type) {
	milli = milli || 1000;
	type = type || "fx";
	return this.queue(type,function(){
		var self = this;
		setTimeout(function(){
			$.dequeue(self);
		},milli);
	});
};

// http://blog.mythin.net/projects/jquery.php
$.fn.clearQueue = $.fn.unpause = function(type) {
	return this.each(function(){
		type = type || "fx";
		if(this.queue && this.queue[type]) {
			this.queue[type].length = 0;
		}
	});
};

// HELPER METHODS

function showAction(action) {
	$('#ActionPane').show();
	
	if($('#ActionPane > .'+action))
		$('#ActionPane > .'+action).show();
}

// to do: pr (just append to body end), empty, isdefined,len for string,array
*/

/*
 EXTERNAL
 Everything below here is external.
*/

/*
 * Javascript Humane Dates
 * Copyright (c) 2008 Dean Landolt (deanlandolt.com)
 * Re-write by Zach Leatherman (zachleat.com)
 * 
 * Adopted from the John Resig's pretty.js
 * at http://ejohn.org/blog/javascript-pretty-date
 * and henrah's proposed modification 
 * at http://ejohn.org/blog/javascript-pretty-date/#comment-297458
 * 
 * Licensed under the MIT license.
 */

function make_date_humane(date_str){
	var time_formats = [
		[60, 'just now'],
		[90, '1 minute'], // 60*1.5
		[3600, 'minutes', 60], // 60*60, 60
		[5400, '1 hour'], // 60*60*1.5
		[86400, 'hours', 3600], // 60*60*24, 60*60
		[129600, '1 day'], // 60*60*24*1.5
		[604800, 'days', 86400], // 60*60*24*7, 60*60*24
		[907200, '1 week'], // 60*60*24*7*1.5
		[2628000, 'weeks', 604800], // 60*60*24*(365/12), 60*60*24*7
		[3942000, '1 month'], // 60*60*24*(365/12)*1.5
		[31536000, 'months', 2628000], // 60*60*24*365, 60*60*24*(365/12)
		[47304000, '1 year'], // 60*60*24*365*1.5
		[3153600000, 'years', 31536000], // 60*60*24*365*100, 60*60*24*365
		[4730400000, '1 century'], // 60*60*24*365*100*1.5
	];

	var time = ('' + date_str).replace(/-/g,"/").replace(/[TZ]/g," "),
		dt = new Date,
		seconds = ((dt - new Date(time) + (dt.getTimezoneOffset() * 60000)) / 1000),
		token = ' ago',
		i = 0,
		format;

	if (seconds < 0) {
		seconds = Math.abs(seconds);
		token = '';
	}

	while (format = time_formats[i++]) {
		if (seconds < format[0]) {
			if (format.length == 2) {
				return format[1] + (i > 1 ? token : ''); // Conditional so we don't return Just Now Ago
			} else {
				return Math.round(seconds / format[2]) + ' ' + format[1] + (i > 1 ? token : '');
			}
		}
	}

	// overflow for centuries
	if(seconds > 4730400000)
		return Math.round(seconds / 4730400000) + ' Centuries' + token;

	return date_str;
};



// http://stackoverflow.com/questions/46155/validate-email-address-in-javascript
function validateEmail(email) {
	var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/ 
	return email.match(re);
}