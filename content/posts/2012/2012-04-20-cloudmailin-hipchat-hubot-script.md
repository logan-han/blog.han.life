---
title: "cloudmailin hipchat hubot script"
date: "2012-04-20"
---

  

Took really long time to deduce workaround...  :S  
Set cloudmailin as  
http://blah.herokuapp.com/hubot/cloudmailin/room\_id  
  
```javascript
# Cloudmailin

http = require(‘http’)
querystring = require(‘querystring’)
auth_token = “supa-secret”

module.exports = (robot) ->
        robot.router.post ‘/hubot/cloudmailin/:room’, (req, res) ->
                post_data = querystring.stringify({
                                room_id: req.params.room,
                                message: “#{req.body.from} – #{req.body.subject}<br>#{req.body.html}”,
                                from: “MailMan”
                        })
                post_options = {
                                host: ‘api.hipchat.com’,
                                port: 80,
                                path: ‘/v1/rooms/message?auth_token=’+auth_token,
                                method: ‘POST’,
                                headers: {
                                        ‘Content-Type’: ‘application/x-www-form-urlencoded’,
                                        ‘Content-Length’: post_data.length
                                }
                        }

                post_req = http.request post_options, (res) ->
                        res.on ‘data’, (chunk) ->
                                console.log(‘Response: ‘ + chunk)
                post_req.write post_data
                post_req.end()
                res.writeHead 200, { ‘Content-Length’: 0 }
                res.end()
```