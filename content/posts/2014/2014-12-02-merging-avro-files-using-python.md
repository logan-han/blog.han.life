---
title: "Merging multiple avro files into single file using python"
date: "2014-12-02"
---

Couldn't find any good example from Web so made one by myself.

It has bits that handling header and footer(it's using bogus footer as it was really FYI only thing for me but you may need to recreate it if it does matter) as well.

Tested on 3MB and 400+ files resulted on 1.2MB single file.

it's quite slow when appending into avro file. Took about 16 secs for 43k rows. Not sure if there's any way to improve it.

```python
#!/usr/bin/python
 
import avro.schema
from avro.datafile import DataFileReader, DataFileWriter
from avro.io import DatumReader, DatumWriter
import os
import sys
import logging
import argparse
 
#parse args
parser = argparse.ArgumentParser(description='Merge avro avro files into single avro file.')
parser.add_argument("-i", "--inputdir", action="store", dest="input_dir", help="Input file directory", required=True)
parser.add_argument("-o", "--outputfile", action="store", dest="output_file", help="Output file name", required=True)
parser.add_argument("-s", "--schemafile", action="store", dest="schema_file", help="Schema file name, default is ./avro_schema.avsc", default="avro_schema.avsc")
parser.add_argument("-q", "--quiet", action="store_false", dest="verbose", help="don't print log messages to stdout", default=True)
args = parser.parse_args()
 
#Add Logging
logger = logging.getLogger()
logger.setLevel(logging.DEBUG)
ch = logging.StreamHandler(sys.stdout)
formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
ch.setFormatter(formatter)
logger.addHandler(ch)
if args.verbose == False:
    ch.setLevel(logging.ERROR)
else:
    ch.setLevel(logging.DEBUG)
 
#init variables
input_dir = args.input_dir
output_file = args.output_file
schema_file = args.schema_file
avrometa = ""
avrorecords = []
avrostats = ""
 
logging.info('Start writing merged data into: %s',output_file)
schema = avro.schema.parse(open(schema_file).read())
writer = DataFileWriter(open(output_file, "w"), DatumWriter(), schema, 'deflate')
 
for target_file in os.listdir(input_dir):
    if target_file.endswith(".avro"):
        avrorecords = []
        logging.info('merging: %s',target_file)
        try:
            target_rows = DataFileReader(open(input_dir+"/"+target_file, "r"), DatumReader())
        except Exception as e:
            raise avro.schema.AvroException(e)
        #need to capture very first file's first line for avrometa, otherwise skip first line to remove avrometa
        if avrometa != "" and avrostats != "":
            next(target_rows)
        for row in target_rows:
            avrorecords.append(row)
        #capture avrometa(header) and bogus avrostats(footer)
        if avrometa == "":
            avrometa = avrorecords[0]
            writer.append(avrometa)
            logging.info('avrometa: %s',avrometa)
            del avrorecords[0]
        if avrostats == "":
            avrostats = avrorecords[-1]
            logging.info('avrostats: %s',avrostats)
        #remove avrostats then append records
        del avrorecords[-1]
        for avrorecord in avrorecords:
            writer.append(avrorecord)
        target_rows.close()
 
writer.append(avrostats)
writer.close()
logging.info('Writing finished. All done.')
```