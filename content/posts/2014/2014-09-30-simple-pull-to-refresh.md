---
title: "Simple pull to refresh"
date: "2014-09-30"
---

1\. Get stuffs from https://github.com/zippy1978/jquery.scrollz

2\. Add below in head section.

<script src="//code.jquery.com/jquery-1.9.1.min.js"></script> <link rel="stylesheet" href="jquery.scrollz.css"/> <script src="jquery.scrollz.min.js"></script>

3\. Add an object with matching id. e.g)<table id="main"

4\. Add below in body section. <script>$(document).ready(function() { $('#main').scrollz({ pull : true }); $('#main').bind('pulled', function() { location.reload();});});</script>
