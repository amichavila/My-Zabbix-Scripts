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

# Get all hostgroups
req    = json_req(auth=myauth, method="hostgroup.get", params={"output": "extended", "sortfield": "name"})
resp   = do_req(myurl, req, user, passwd)

groups = resp['result']

for group in groups:
	print ">> Grupo '{name}' Id: {idg}".format(name=group['name'], idg=group['groupid'])
	
	# Get all hosts by groupid
	req    = json_req(auth=myauth, method="host.get", params={"output": "extended", "filter": {"groupid": group['groupid']}})
	resp   = do_req(myurl, req, user, passwd)
	print resp

exit()
