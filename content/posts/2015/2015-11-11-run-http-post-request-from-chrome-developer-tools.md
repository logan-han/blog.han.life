---
title: "Run HTTP POST request from chrome developer tools"
date: "2015-11-11"
---

Do this from developer mode console.

May need to load a page from the same domain to avoid cross domain validation failure.

`var xhr = new XMLHttpRequest(); xhr.open('POST', 'http://url_here', true); xhr.setRequestHeader('Content-type', 'application/json'); xhr.onload = function () { // do something to response console.log(this.responseText); }; xhr.send('query_here');`
