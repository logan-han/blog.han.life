---
title: "Flume DFO local storage usage check"
date: "2012-01-30"
---

It might be useful when flume driver failed.  
```perl
!/usr/bin/perl
#Check flume DFO directory size

sub trim($);
use strict;
use warnings;

my $exit=0;
my $backlog_size = `du -s flume | awk {‘print \$1’}`;
$backlog_size = trim($backlog_size);

if ( !$ARGV[0] || !$ARGV[1])
{
########################### Usage of the plugin
print “check_flume_backlog critical_size warning_size   \n”;
exit 0;
}

######################### Case 1 if State is Critical
if ($backlog_size > $ARGV[0])
{
print “Critical: “.$backlog_size.”b\n”;
exit 2;
}

######################## Case 2 if State is Warning
if($backlog_size > $ARGV[1] || $backlog_size == 0)
{
print “Warning: “.$backlog_size.”b\n”;
exit 1;
}

######################## Case 3 if State is OK
if($backlog_size < $ARGV[0] && $backlog_size < $ARGV[1])
{
print “OK: “.$backlog_size.”b\n”;
exit 0;
}

sub trim($)
{
        my $string = shift;
        $string =~ s/^\s+//;
        $string =~ s/\s+$//;
        return $string;
}
```
  
  
And for centralised monitoring..  
```php
#!/usr/bin/php
<?php
//Check flume DFO directory size from all collection servers

// default warning 500MB
if(!isset($argv[1])) $warning = “5000000000”;
else $warning = $argv[1];
// default critical 1GB
if(!isset($argv[2])) $critical = “10000000000”;
else $critical = $argv[2];

$servers = array();
$results = “”;
$total = 0;
$ok = 0;
$warning_list = “”;
$critical_list = “”;

//-snip-  get server lists from nagios

foreach($servers as $server)
{
        //echo $server.”\n”;
        $cmd = “check_nrpe -H $server -c check_flume_backlog -a ‘$critical $warning'”;
        $result = “[“.$server.”] “.exec($cmd).”\n”;

        $total++;
        if(preg_match(“/OK/”,$result)) $ok++;
        else if(preg_match(“/Warning/”,$result)) $warning_list.=$server.”,”;
        else if(preg_match(“/Critical/”,$result)) $critical_list.=$server.”,”;

        $results.=$result;
}

if(!empty($critical_list)) $notification = “CRITICAL: “.$critical_list;
else if(!empty($warning_list))  $notification = “WARNING: “.$warning_list;
else $notification = “OK: “.$ok.”/”.$total;

echo $notification.”\n”.$results;

?>
```
