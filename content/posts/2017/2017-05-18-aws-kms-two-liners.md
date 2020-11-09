---
title: "AWS KMS - two liners"
date: "2017-05-18"
---

For binary encrypted output: \[bash\]aws kms encrypt --region ap-southeast-2 --key-id alias/blah --plaintext fileb://blah --output text --query CiphertextBlob | base64 --decode > blah.enc aws kms decrypt --ciphertext-blob fileb://blah.enc --output text --query Plaintext | base64 --decode\[/bash\]

For base64 encrypted output: \[bash\]aws kms encrypt --region ap-southeast-2 --key-id alias/blah --plaintext fileb://blah --output text --query CiphertextBlob > blah.enc aws kms decrypt --ciphertext-blob fileb://<(cat blah.enc | base64 --decode) --output text --query Plaintext | base64 --decode\[/bash\]

or try: https://github.com/realestate-com-au/shush
