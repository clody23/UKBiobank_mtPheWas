#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import xml.etree.ElementTree as ET
import traceback
import logging
import json


c = 0
dic = {}
for event, elem in ET.iterparse(sys.argv[1], events=('start', 'end')):
	if event == 'end':
		if 'name' in elem.tag:
			if elem.tag not in dic:
				key = elem.text
				c += 1
				print c
		elif 'mechanism-of-action' in elem.tag:
			if key not in dic:
				dic[key] = [elem.text]
			else:
				pass
		else:
			pass

print "Dumping dictionary in json file...\n"
with open('./drugbank_parsed.json','a') as db:
	json.dump(dic,db)


