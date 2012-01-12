#!/usr/bin/env python

#
# This script count all VBDs for a specific VM
#

import LuchoXenAPI
import optparse

parser = optparse.OptionParser()
parser.add_option('-s'  , '--server'  , help='Your xen server IP.')
parser.add_option('-P'  , '--protocol', help='Use http or https.')
parser.add_option('-p'  , '--port'    , help='Port to connect to your server.')
parser.add_option('-u'  , '--user'    , help='The user to connect to the server.')
parser.add_option('-w', '--password'  , help='The user password to connect to your server.')
parser.add_option('-n' , '--vmname'   , help='Your virtual machine name to search.')
(options,args) = parser.parse_args()

server = LuchoXenAPI.XenAPI(server=options.server, protocol=options.protocol, port=options.port, user=options.user, password=options.password)

try:
	server.login()
	print server.count_vm_vbds(server.getvm_pername(options.vmname))
	server.logout()
except:
	# -1 seems that an error has ocurred.
	print "ERROR"

exit()
