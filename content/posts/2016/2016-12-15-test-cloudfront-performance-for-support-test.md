---
title: "Curl net performance test"
date: "2016-12-15"
---

Print out CloudFront X-Amz-Cf-Id when response time is slower than set threshold.

\[code lang="bash"\] #!/bin/bash

output=($(curl -I -s -w "Time: %{time\_total}\\n" http://cf\_url.here grep -e X-Amz-Cf-Id -e Time | awk {'print $2'}))

id=${output\[0\]} time=${output\[1\]} compare=0.01

if (( $(echo "$time > $compare" |bc -l) )); then echo $time - $id >> test\_results.txt fi \[/code\]

Small variation (unrelated to CF) \[code lang="bash"\] #!/bin/bash while : do output=($(curl -o /dev/null -s -w "time\_namelookup: %{time\_namelookup}\\n time\_connect: %{time\_connect}\\n time\_appconnect: %{time\_appconnect}\\n time\_pretransfer: %{time\_pretransfer}\\n time\_redirect: %{time\_redirect}\\n time\_starttransfer: %{time\_starttransfer}\\n time\_total: %{time\_total}\\n" http://services.realestate.com.au/services/listings/120542701 | grep time\_ | awk {'print $2'}))

time\_namelookup=${output\[0\]} time\_connect=${output\[1\]} time\_appconnect=${output\[2\]} time\_pretransfer=${output\[3\]} time\_redirect=${output\[4\]} time\_starttransfer=${output\[5\]} time\_total=${output\[6\]} compare=0.1

if (( $(echo "$time\_total &gt; $compare" |bc -l) )); then echo $time\_namelookup,$time\_connect,$time\_appconnect,$time\_pretransfer,$time\_redirect,$time\_starttransfer,$time\_total &gt;&gt; test\_results.txt fi sleep 1 done \[/code\]
