---
title: "ZeroMQ - PHP client & Python server with multi part message example"
date: "2012-05-02"
---

  
Using pyobj or php data serialisation is not an option in this case..  
  
Client:  
  
<?php  
$context = new ZMQContext();  
$requester = new ZMQSocket($context, ZMQ::SOCKET\_REQ);  
$requester->connect("tcp://localhost:9999");  
$requester->send("Filename",ZMQ::MODE\_SNDMORE);  
$requester->send("Log",ZMQ::MODE\_NOBLOCK);  
?>  
  
Server:  
  

import zmq  

context = zmq.Context()  
socket = context.socket(zmq.REP)  
socket.bind("tcp://\*:9999")

  
while True:  
  
message = socket.recv\_multipart()  
print message\[0\]+":"+message\[1\]  
socket.send("OK",zmq.NOBLOCK)
