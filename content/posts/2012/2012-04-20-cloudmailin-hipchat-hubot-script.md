---
title: "cloudmailin hipchat hubot script"
date: "2012-04-20"
---

  

Took really long time to deduce workaround...  :S  
Set cloudmailin as  
http://blah.herokuapp.com/hubot/cloudmailin/room\_id  
  
  
\# Cloudmailin  
  
http = require('http')  
querystring = require('querystring')  
auth\_token = "supa-secret"  
  
module.exports = (robot) ->  
        robot.router.post '/hubot/cloudmailin/:room', (req, res) ->  
                post\_data = querystring.stringify({  
                                room\_id: req.params.room,  
                                message: "#{req.body.from} - #{req.body.subject}<br>#{req.body.html}",  
                                from: "MailMan"  
                        })  
                post\_options = {  
                                host: 'api.hipchat.com',  
                                port: 80,  
                                path: '/v1/rooms/message?auth\_token='+auth\_token,  
                                method: 'POST',  
                                headers: {  
                                        'Content-Type': 'application/x-www-form-urlencoded',  
                                        'Content-Length': post\_data.length  
                                }  
                        }  
  
                post\_req = http.request post\_options, (res) ->  
                        res.on 'data', (chunk) ->  
                                console.log('Response: ' + chunk)  
                post\_req.write post\_data  
                post\_req.end()  
                res.writeHead 200, { 'Content-Length': 0 }  
                res.end()
