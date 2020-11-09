---
title: "Python - write compressed log file into HDFS for hadoop hive mapreduce"
date: "2012-03-01"
---

```python
import pyhdfs
from cStringIO import StringIO
import binascii

-snip-

#Set hdfs connection info
hdfsaddress = “namenode”
hdfsport = 12345
hdfsfn = “filename”

#gzip compression level
clevel = 1

-snip-

      logger.info(“Writing compressed data into ” + hdfsfn + “.gz”)
        #open hdfs file
        fout = pyhdfs.open(hdfs, hdfsfn + “.gz”, “w”)
        #compress the data and store it in compressed_data
        buf = StringIO()
        f = gzip.GzipFile(mode=’wb’, compresslevel=clevel,fileobj=buf)
        try:
                f.write(concatlog)
        finally:
                f.close()
        compressed_data = buf.getvalue()
        #write compressed data into hdfs
        pyhdfs.write(hdfs,fout,compressed_data)
        #close hdfs file
        logger.info(“Writing task finished”)
        pyhdfs.close(hdfs,fout)
-snip-
```