---
title: "Facebook scribe with hdfs"
date: "2012-02-17"
---

packages:  
libevent  
hadoop-0.20-libhdfs  
JDK for hdfs support  
  
Boost  
http://sourceforge.net/projects/boost/  
./bootstrap.sh  
./bjam  
./bjam install  
  
thrift  
download form http://thrift.apache.org/download/  
./configure  
make  
make install  
  
fb303  
it's in <thrift source>/contrib/fb303  
  
./bootstrap.sh  
./configure CPPFLAGS="-DHAVE\_INTTYPES\_H -DHAVE\_NETINET\_IN\_H"  
(To avoid compile error, recompile thrift with this option if it doesn't work)  
make  
make install  
  
Download  
git clone https://github.com/facebook/scribe.git  
ln -s /usr/java/jdk1.6.0\_31/jre/lib/amd64/server/libjvm.so /usr/lib/  
./configure --enable-hdfs CPPFLAGS="-DHAVE\_INTTYPES\_H -DHAVE\_NETINET\_IN\_H -I/usr/java/jdk1.6.0\_31/include -I/usr/java/jdk1.6.0\_31/include/linux -I/tmp/boost\_1\_45\_0"  
make  
make install  
  
  
Run  
export LD\_LIBRARY\_PATH="/usr/local/lib/;/usr/lib";  
export CLASSPATH=/usr/lib/hadoop-0.20/hadoop-core.jar:/usr/lib/hadoop-0.20/lib/commons-logging-1.0.4.jar:/usr/lib/hadoop-0.20/lib/guava-r09-jarjar.jar  
scribed  
  
Speed  
Approx. 200MB per second (uncompressed)  
Approx. 18MB per second with gzip -9
