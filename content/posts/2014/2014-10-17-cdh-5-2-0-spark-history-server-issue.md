---
title: "CDH 5.2.0 spark history server issue"
date: "2014-10-17"
---

5.2.0-1.cdh5.2.0.p0.36 has been released couple of days ago.

It has a small bug with its spark bit, which make unable to start spark history server.

The problem is the default value of Spark History Location (=spark.eventLog.dir) is /user/spark/applicationHistory and it doesn't append hdfs header by default, hence get recognised as local drive rather than HDFS.

Workaround:

Apply hdfs:///user/spark/applicationHistory instead.
