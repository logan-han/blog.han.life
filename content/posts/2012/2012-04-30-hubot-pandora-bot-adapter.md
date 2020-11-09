---
title: "hubot pandora bot adapter"
date: "2012-04-30"
---

```javascript
# Chat with pandora bot
#
# ai <anything> – PANDORA AI
#

QS = require “querystring”
xml2js = require ‘xml2js’

module.exports = (robot) ->
        robot.respond /(ai|AI)( me)? (.*)/i, (msg) ->
                user = msg.message.user.name
                query = msg.match[3]
                botid = “meh”
                parser = new xml2js.Parser({explicitArray: true})
                msg.http(“http://www.pandorabots.com/pandora/talk-xml”)
                        .query({
                        botid: botid
                        custid: user
                        input: query
                        })
                        .post() (err, resp, body) ->
                                parser.parseString body, (err, result) ->
                                        #console.log(result.that)
                                        msg.send result.that
```