---
title: Add HTTP auth username into envoy proxy logging
date: 2021-06-01
description: Dodgy way to extract username from Authorization http header

---
Oddly couldn't find any useful copy & paste solution for this.

As always, base64 decoding and split function copy & pasted from somewhere else.

```yaml
http_filters:
- name: envoy.filters.http.lua
typed_config:
  "@type": type.googleapis.com/envoy.extensions.filters.http.lua.v3.Lua
  inline_code: |
    b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    function base64decode(data)
        data = string.gsub(data, '[^'..b..'=]', '')
        return (data:gsub('.', function(x)
            if (x == '=') then return '' end
            local r,f='',(b:find(x)-1)
            for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
            return r;
        end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
            if (#x ~= 8) then return '' end
            local c=0
            for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
            return string.char(c)
        end))
    end
    function split(s, delimiter)
        result = {};
        for match in (s..delimiter):gmatch("(.-)"..delimiter) do
            table.insert(result, match);
        end
        return result;
    end
    function envoy_on_request(request_handle)
      local auth_header = request_handle:headers():get("Authorization")
      if auth_header ~= nil then
        local auth_token = split(auth_header," ")
        if auth_token[1] == "Basic" then
          local auth_decoded = split(base64decode(auth_token[2]),":")
          request_handle:headers():replace("x-username", auth_decoded[1])
          auth_header = null
          auth_token = null
          autn_decoded = null
        end
      end
    end
- name: envoy.filters.http.router
typed_config: {}
```

Then it can be added into the log by using `%REQ(x-username)%` from `envoy.extensions.access_loggers.file.v3.FileAccessLog.format`