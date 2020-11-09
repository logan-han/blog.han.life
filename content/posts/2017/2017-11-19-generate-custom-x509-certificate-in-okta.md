---
title: "Generate custom x509 certificate in Okta"
date: "2017-11-19"
---

\* Requires API key with admin access, least for the target app

Obtain app name & label using app ID 

```sh
curl -v -X GET \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: SSWS ${api_token}" \
"https://[okta_instance].okta.com/api/v1/apps/[app_id]"
```

Generate custom certificate and capture 'kid' value from response
```sh
curl -v -X POST \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: SSWS ${api_token}" \
-d '{
}' "https://[okta_instance].okta.com/api/v1/apps/[app_id]/credentials/keys/generate?validityYears=[number]"
```

Inject the generated custom certificate to the app
```sh
curl -v -X PUT \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: SSWS ${api_token}" \
-d '{
  "name": "[app_name]",
  "label": "[app_label]",
  "signOnMode": "SAML_2_0",
  "credentials": {
    "signing": {
      "kid": "[kid]"
    }
  }
 }
}' "https://[okta_instnace].okta.com/api/v1/apps/[app_id]"
```