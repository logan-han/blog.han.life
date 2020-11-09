---
title: "Salesforce CLI with Docker in AWS"
date: "2019-06-28"
---

Auth was the tricky part as the normal auth requires a browser session rather than taking it from the CLI prompt.

Step 1. Create Dockerfile  
  
```sh
FROM node:9.9.0-alpine  
RUN npm install sfdx-cli --global  
RUN sfdx --version  
RUN sfdx plugins --core
```

Step 2. Generate auth URL from your laptop and push into SSM  
```sh
sfdx force:auth:web:login -r https://test.salesforce.com -a <alias>  
sfdx force:org:display -u <alias> --verbose
```

Step 3. Push the auth URL into SSM  
Note: Auth URL looks like - force://......salesforce.com  
`aws ssm put-parameter --name /SF/dev --value <auth_URL_here> --description 'some description' --type SecureString --key-id <KMS_key_id_here> --region <region_here> --overwrite`  
  
To list all the keys in the path:  
`aws ssm get-parameters-by-path --path /SF/ --query 'Parameters[*].Name'`  

Step 4. Run auth within the docker container  
```sh
aws ssm get-parameters --name <name_here> --with-decryption --output text --query 'Parameters[*].Value' --region ap-southeast-2 > auth.txt"  
sfdx force:auth:sfdxurl:store -f auth.txt -a <alias_here>
```
you probably don't need to worry about auth.txt if you're using docker --rm or similar.
