---
title: "Log compression for Cloudera Manager Hadoop"
date: "2014-07-04"
---

Cloudera manager uses standard log4j which doesn't support compression by itself.

It requires Apache Extras™ for Apache log4j™ (http://logging.apache.org/log4j/extras/) or maybe log4j2.

Load log4j-(latest version).jar by placing it under /lib of CDH parcel or custom import.

Paste below into 'Logging Safety Valve' under advance tab: `log4j.appender.RFA=org.apache.log4j.rolling.RollingFileAppender log4j.appender.RFA.rollingPolicy=org.apache.log4j.rolling.FixedWindowRollingPolicy log4j.appender.RFA.rollingPolicy.FileNamePattern=${hadoop.log.dir}/${hadoop.log.file}-%i.log.gz log4j.appender.RFA.rollingPolicy.MinIndex=1 log4j.appender.RFA.rollingPolicy.MaxIndex=${hadoop.log.maxbackupindex} log4j.appender.RFA.triggeringPolicy=org.apache.log4j.rolling.SizeBasedTriggeringPolicy log4j.appender.RFA.triggeringPolicy.MaxFileSize=209715200`

Note: Need to change 'hadoop' to 'zookeeper' for zookeeper etc.

Attemped to use time based rolling instead of size but no dice, someone mentioned: "The TimeBasedRollingPolicy does not work when used as a TriggeringPolicy. The implementation of isTriggeringEvent(..) depends on a 'nextCheck' variable which is only updated through rollover() method (not invoked because it is not being used as the the rolling policy)."

It will also trigger couple of warnings as it's overriding default cloudera log4j properties.

${hadoop.log.maxfilesize} cannot be used for MaxFileSize as it writes '123MB' in string rather than convert it into bytes whereas MaxFileSize only accepts byte format.
