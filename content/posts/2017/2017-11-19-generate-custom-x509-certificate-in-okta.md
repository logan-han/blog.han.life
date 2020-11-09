---
title: "Generate custom x509 certificate in Okta"
date: "2017-11-19"
---

\* Requires API key with admin access, least for the target app

Obtain app name & label using app ID \[bash\] curl -v -X GET \\ -H "Accept: application/json" \\ -H "Content-Type: application/json" \\ -H "Authorization: SSWS ${api\_token}" \\ "https://\[okta\_instance\].okta.com/api/v1/apps/\[app\_id\]" \[/bash\]

Generate custom certificate and capture 'kid' value from response \[bash\] curl -v -X POST \\ -H "Accept: application/json" \\ -H "Content-Type: application/json" \\ -H "Authorization: SSWS ${api\_token}" \\ -d '{ }' "https://\[okta\_instance\].okta.com/api/v1/apps/\[app\_id\]/credentials/keys/generate?validityYears=\[number\]" \[/bash\]

Inject custom certificate to app \[bash\] curl -v -X PUT \\ -H "Accept: application/json" \\ -H "Content-Type: application/json" \\ -H "Authorization: SSWS ${api\_token}" \\ -d '{ "name": "\[app\_name\]", "label": "\[app\_label\]", "signOnMode": "SAML\_2\_0", "credentials": { "signing": { "kid": "\[kid\]" } } } }' "https://\[okta\_instnace\].okta.com/api/v1/apps/\[app\_id\]" \[/bash\]
