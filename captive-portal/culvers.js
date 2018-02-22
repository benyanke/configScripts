#!/usr/bin/phantomjs

var page = require('webpage').create();

console.log('The default user agent is ' + page.settings.userAgent);
page.settings.userAgent = 'SpecialAgent';

// page.open('http://null.publicserver.xyz', function(status) {
page.open('http://10.100.100.254:1000', function(status) {
  if (status !== 'success') {
    console.log('Unable to access network');
  } else {
    var ua = page.evaluate(function() {
	document.getElementById('myagent').textContent;

	// accept function
	document.forms[0].answer.value="1";
	document.forms[0].submit();

      return "done";
    });
    console.log(ua);
  }
  phantom.exit();
});
