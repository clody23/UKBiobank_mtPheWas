#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import json

ifile,out = sys.argv[1:]

ifile = open(ifile,'r')
j = ifile.read()

out = open(out,'w')
jdata = json.loads(j)
for k,v in jdata.iteritems():
	k = k.encode('utf-8').strip()
	if v == []:
		out.write(str(k)+'\t'+"NA\n")
	else:
		new_v = []
		for i in v:
			if i == None:
				i = str(i)
				new_v.append(i)
			else:
				i = i.encode('utf-8').strip()
				new_v.append(i)	
		o = ','.join(new_v)
		out.write(str(k)+'\t'+o+'\n')

out.close()
