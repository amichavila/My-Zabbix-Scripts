#!/usr/bin/env python

import json
import urllib2
import base64
import string
import optparse

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

parser = optparse.OptionParser()
parser.add_option('-r'  , '--url'     , help='Your zabbix api url without \'https://\'.')
parser.add_option('-u'  , '--user'    , help='The user to connect to the zabbix server.')
parser.add_option('-w', '--password'  , help='The user password to connect to your zabbix server.')
parser.add_option('-p'  , '--protocol', help='You only can use https. This items was added only for help.')
(options,args) = parser.parse_args()

user   = options.user
passwd = options.password
myurl  = "https://" + str(options.url)

# Logging and get auth value from zabbix server
req    = json_req(auth=None, method="user.authenticate", params={"user": user, "password": passwd})
resp   = do_req(myurl, req, user, passwd)
myauth = resp['result']

# Get all hosts in server
req    = json_req(auth=myauth, method="host.get", params={"output": "extend"})
resp   = do_req(myurl, req, user, passwd)

for host in resp['result']:
	print host['host']

exit()
