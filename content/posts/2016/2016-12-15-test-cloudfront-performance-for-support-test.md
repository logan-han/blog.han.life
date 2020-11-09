---
title: "Curl net performance test"
date: "2016-12-15"
---

Print out CloudFront X-Amz-Cf-Id when response time is slower than set threshold.

```sh
#!/bin/bash
 
output=($(curl -I -s -w "Time: %{time_total}\n"  http://cf_url.here grep -e X-Amz-Cf-Id -e Time | awk {'print $2'}))
 
id=${output[0]}
time=${output[1]}
compare=0.01
 
if (( $(echo "$time > $compare" |bc -l) )); then
    echo $time - $id >> test_results.txt
fi

```

Small variation (unrelated to CF) 

```sh
#!/bin/bash
while :
do
output=($(curl -o /dev/null -s -w "time_namelookup: %{time_namelookup}\n time_connect: %{time_connect}\n time_appconnect: %{time_appconnect}\n time_pretransfer: %{time_pretransfer}\n time_redirect: %{time_redirect}\n time_starttransfer: %{time_starttransfer}\n time_total: %{time_total}\n" http://services.realestate.com.au/services/listings/120542701 | grep time_ | awk {'print $2'}))
 
time_namelookup=${output[0]}
time_connect=${output[1]}
time_appconnect=${output[2]}
time_pretransfer=${output[3]}
time_redirect=${output[4]}
time_starttransfer=${output[5]}
time_total=${output[6]}
compare=0.1
 
if (( $(echo "$time_total &gt; $compare" |bc -l) )); then
echo $time_namelookup,$time_connect,$time_appconnect,$time_pretransfer,$time_redirect,$time_starttransfer,$time_total &gt;&gt; test_results.txt
fi
sleep 1
done
```