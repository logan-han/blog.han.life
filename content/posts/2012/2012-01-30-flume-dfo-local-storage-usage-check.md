---
title: "Flume DFO local storage usage check"
date: "2012-01-30"
---

It might be useful when flume driver failed.  

> #!/usr/bin/perl  
> #Check flume DFO directory size  
>   
> sub trim($);  
> use strict;  
> use warnings;  
>   
> my $exit=0;  
> my $backlog\_size = \`du -s flume | awk {'print \\$1'}\`;  
> $backlog\_size = trim($backlog\_size);  
>   
> if ( !$ARGV\[0\] || !$ARGV\[1\])  
> {  
> ########################### Usage of the plugin  
> print "check\_flume\_backlog critical\_size warning\_size   \\n";  
> exit 0;  
> }  
>   
> ######################### Case 1 if State is Critical  
> if ($backlog\_size > $ARGV\[0\])  
> {  
> print "Critical: ".$backlog\_size."b\\n";  
> exit 2;  
> }  
>   
> ######################## Case 2 if State is Warning  
> if($backlog\_size > $ARGV\[1\] || $backlog\_size == 0)  
> {  
> print "Warning: ".$backlog\_size."b\\n";  
> exit 1;  
> }  
>   
> ######################## Case 3 if State is OK  
> if($backlog\_size < $ARGV\[0\] && $backlog\_size < $ARGV\[1\])  
> {  
> print "OK: ".$backlog\_size."b\\n";  
> exit 0;  
> }  
>   
> sub trim($)  
> {  
>         my $string = shift;  
>         $string =~ s/^\\s+//;  
>         $string =~ s/\\s+$//;  
>         return $string;  
> }

  
  
And for centralised monitoring..  
   

> #!/usr/bin/php  
> <?php  
> //Check flume DFO directory size from all collection servers  
>   
> // default warning 500MB  
> if(!isset($argv\[1\])) $warning = "5000000000";  
> else $warning = $argv\[1\];  
> // default critical 1GB  
> if(!isset($argv\[2\])) $critical = "10000000000";  
> else $critical = $argv\[2\];  
>   
> $servers = array();  
> $results = "";  
> $total = 0;  
> $ok = 0;  
> $warning\_list = "";  
> $critical\_list = "";  
>   
> //-snip-  get server lists from nagios  
>   
> foreach($servers as $server)  
> {  
>         //echo $server."\\n";  
>         $cmd = "check\_nrpe -H $server -c check\_flume\_backlog -a '$critical $warning'";  
>         $result = "\[".$server."\] ".exec($cmd)."\\n";  
>   
>         $total++;  
>         if(preg\_match("/OK/",$result)) $ok++;  
>         else if(preg\_match("/Warning/",$result)) $warning\_list.=$server.",";  
>         else if(preg\_match("/Critical/",$result)) $critical\_list.=$server.",";  
>   
>         $results.=$result;  
> }  
>   
> if(!empty($critical\_list)) $notification = "CRITICAL: ".$critical\_list;  
> else if(!empty($warning\_list))  $notification = "WARNING: ".$warning\_list;  
> else $notification = "OK: ".$ok."/".$total;  
>   
> echo $notification."\\n".$results;  
>   
> ?>
