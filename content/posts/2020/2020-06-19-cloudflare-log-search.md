---
title: "CloudFlare Log Search"
date: "2020-06-19"
---

1. Get the Zone ID  
    Select domain name from the dashboard then zone ID will show on bottom right corner.
2. Get the API Key  
    Select log search template to give minimum privilege
3. (Optional) Look up the fields available  
    

curl -s -H "X-Auth-Email: <EMAIL>" -H "Authorization: Bearer <API KEY>" "https://api.cloudflare.com/client/v4/zones/<Zone ID>/logs/received/fields" | jq .

4\. Run Log Search (modify date & time bit as you need)  

curl -s \\
    -H "X-Auth-Email: <EMAIL>" \\
    -H "Authorization: Bearer <API KEY>" \\
    "https://api.cloudflare.com/client/v4/zones/<ZONE ID>/logs/received?start=2020-06-18T17:21:37Z&end=2020-06-18T17:38:01Z&fields=ClientRequestPath,ClientIP,ClientRequestUserAgent,EdgeResponseStatus,OriginResponseStatus,EdgeStartTimestamp,EdgeEndTimestamp" > temp.txt

5\. Filter Logs (Adjust the condition as you need)

cat temp.txt | jq 'select(.ClientIP == "<IP>" and .ClientRequestPath == "<ENDPOINT>") | .EdgeStartTimestamp |= (. / 1000000000 | strftime("%Y-%m-%d %H:%M:%S UTC")) | .EdgeEndTimestamp |= (. / 1000000000 | strftime("%Y-%m-%d %H:%M:%S UTC"))'
