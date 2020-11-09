---
title: "Merging multiple avro files into single file using python"
date: "2014-12-02"
---

Couldn't find any good example from Web so made one by myself.

It has bits that handling header and footer(it's using bogus footer as it was really FYI only thing for me but you may need to recreate it if it does matter) as well.

Tested on 3MB and 400+ files resulted on 1.2MB single file.

it's quite slow when appending into avro file. Took about 16 secs for 43k rows. Not sure if there's any way to improve it.

\[code language="python"\] #!/usr/bin/python

import avro.schema from avro.datafile import DataFileReader, DataFileWriter from avro.io import DatumReader, DatumWriter import os import sys import logging import argparse

#parse args parser = argparse.ArgumentParser(description='Merge avro avro files into single avro file.') parser.add\_argument("-i", "--inputdir", action="store", dest="input\_dir", help="Input file directory", required=True) parser.add\_argument("-o", "--outputfile", action="store", dest="output\_file", help="Output file name", required=True) parser.add\_argument("-s", "--schemafile", action="store", dest="schema\_file", help="Schema file name, default is ./avro\_schema.avsc", default="avro\_schema.avsc") parser.add\_argument("-q", "--quiet", action="store\_false", dest="verbose", help="don't print log messages to stdout", default=True) args = parser.parse\_args()

#Add Logging logger = logging.getLogger() logger.setLevel(logging.DEBUG) ch = logging.StreamHandler(sys.stdout) formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s') ch.setFormatter(formatter) logger.addHandler(ch) if args.verbose == False: ch.setLevel(logging.ERROR) else: ch.setLevel(logging.DEBUG)

#init variables input\_dir = args.input\_dir output\_file = args.output\_file schema\_file = args.schema\_file avrometa = "" avrorecords = \[\] avrostats = ""

logging.info('Start writing merged data into: %s',output\_file) schema = avro.schema.parse(open(schema\_file).read()) writer = DataFileWriter(open(output\_file, "w"), DatumWriter(), schema, 'deflate')

for target\_file in os.listdir(input\_dir): if target\_file.endswith(".avro"): avrorecords = \[\] logging.info('merging: %s',target\_file) try: target\_rows = DataFileReader(open(input\_dir+"/"+target\_file, "r"), DatumReader()) except Exception as e: raise avro.schema.AvroException(e) #need to capture very first file's first line for avrometa, otherwise skip first line to remove avrometa if avrometa != "" and avrostats != "": next(target\_rows) for row in target\_rows: avrorecords.append(row) #capture avrometa(header) and bogus avrostats(footer) if avrometa == "": avrometa = avrorecords\[0\] writer.append(avrometa) logging.info('avrometa: %s',avrometa) del avrorecords\[0\] if avrostats == "": avrostats = avrorecords\[-1\] logging.info('avrostats: %s',avrostats) #remove avrostats then append records del avrorecords\[-1\] for avrorecord in avrorecords: writer.append(avrorecord) target\_rows.close()

writer.append(avrostats) writer.close() logging.info('Writing finished. All done.') \[/code\]
