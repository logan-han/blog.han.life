---
title: "MongoDB to DynamoDB"
date: "2016-06-08"
---

Attempted to convert rather large mongo dump to dynamo.

Seems like AWS data pipeline is most elegant way to do this if one can workaround with dynamo non-standard json format issue.

Get https://www.npmjs.com/package/dyngodb2 and create a collection

export json and run some sed to trim \[bash\]mongoexport --db=wiki --collection=wiki -f title,text > output.json sed -i 's/{ \\"$oid\\" : \\"/"/g;s/\\" }, \\"/", "/g;s/{{{//g;s/}}}//g;s/{{//g;s/}}//g;s/$/,/g;' output.json \[/bash\]

split file to avoid OOM, adjust 30000 based on your free ram then add \[ and replace trailing, with \] \[bash\] split -l 30000 output.json sed -i '1s/^/\[/;$s/,$/\]/' x\* \[/bash\]

import & make a batch process to do all sliced files \[bash\] dyngodb2 < db.wiki.save(json('xaa')) \[/bash\]

\[bash\] { "operation": "echo", "TableName": "Thread", "Key": { "title-index": "!" } } \[/bash\]
