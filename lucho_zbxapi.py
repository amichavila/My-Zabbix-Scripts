#!/usr/bin/env python

import json
import urllib2
import base64
import string

#
# Functions
#

def json_req(auth, method, params={}):
	myjson = { 'jsonrpc': '2.0',
 	           'method' : method,
	           'params' : params,
	           'auth'   : auth,
	           'id'     : 0 
	         }
	return json.dumps(myjson)


def do_req(myurl, json_req, user, passwd):
	auth_http='Basic ' + string.strip(base64.encodestring(user + ':' + passwd))
	headers = { 'Content-Type' : 'application/json-rpc',
                 'User-Agent'   : 'python/zabbix_api',
	            'Authorization': auth_http
               }
	request = urllib2.Request(url=myurl, data=json_req,headers=headers)
	https_handler = urllib2.HTTPSHandler(debuglevel=0)
	opener = urllib2.build_opener(https_handler)
	urllib2.install_opener(opener)
	response = opener.open(request,timeout=50)
	reads = response.read()
	jresp = json.loads(reads)
	return jresp

## This is a simple generator
def get_results(json_resp):
	i = 0
	while True:
		try:
			yield json_resp['result'][i]
			i += 1
		except IndexError:
			break

#
# Main Code
#

user   = "api"
passwd = "password"
myurl  = "https://server/zabbix/api_jsonrpc.php"

# Logging and get auth value from zabbix server
req    = json_req(auth=None, method="user.authenticate", params={"user": user, "password": passwd})
resp   = do_req(myurl, req, user, passwd)
myauth = resp['result']
print myauth

# Get all hosts in server
#req    = json_req(auth=myauth, method="host.get", params={"output": "extend"})
#resp   = do_req(myurl, req, user, passwd)
#
#for result in get_results(resp):
#	print "HostID: {ID} \t Host:{HOST}".format(ID=result['hostid'], HOST=result['host'])

# To this block works properly you must make some changes. Please, read change_api.
req    = json_req(auth=myauth, method='item.get', params={'output': 'extend', 'filter': {"key_": "vfs.fs.size[%,total]"}})
resp   = do_req(myurl, req, user, passwd)
print json.dumps(resp, indent=4)

exit()
