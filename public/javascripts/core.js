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

// http://stackoverflow.com/questions/46155/validate-email-address-in-javascript
function validateEmail(email) {
	var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/ 
	return email.match(re);
}

String.prototype.trim=function(){a=this.replace(/^\s+/,'');return a.replace(/\s+$/,'');};

// to do: pr (just append to body end), empty, isdefined,len for string,array
*/