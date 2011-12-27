#!/usr/bin/env python

#
# This python program count all VBDs for a specific vm.
# I have modified my XenAPI to do it...
# lucho -The black hawk- <luislopez72@gmail.com>
#

import xmlrpclib, sys, logging


#
# Functions
#

# This function log all errors to a file
def logerrors(msg):
	logging.debug(msg)

# This function is used to login and it returns the session id.
def login(xen_server, user, password):
	login    = xen_server.session.login_with_password(user, password)
	check_response(response = login)
	session  = login['Value']
	return session

# This function is used to logout or close the session.
def logout(session):
	xen.session.logout(session)

# This function is used to check the xen server response.
def check_response(response):
	if response['Status'] == "Failure":
		logerrors("An error has ocurred:" + str(response['ErrorDescription']))
		pass
	if not response['Status'] == "Success":
		logerrors("An error has ocurred: Please report this error...", "Status is not Success.")
		pass
	if not response.has_key('Value'):
		logerrors("I can't found 'Value' key in the response dictionary...")
		pass

# This function is used to get only 'OpaqueRef' of all vms.
def getall_vms(xen_server, session):
	allvms = xen_server.VM.get_all(session)
	check_response(response = allvms)
	return allvms['Value']

# This function is used to get all vm records (information about) where vm is OpaqueRef
def get_vm_records(xen_server, session, vm):
	records = xen_server.VM.get_record(session, vm)
	check_response(response = records)
	return records['Value']

# This function is used to count VBDs of a specific vm.
def count_vm_vbds(xen_server, session, vm):
	vmrecords = get_vm_records(xen_server = xen_server, session = session, vm = vm)
	return len(vmrecords['VBDs'])

# This function is used to get 'OpaqueRef' by vm name
def getvm_pername(xen_server, session, vmname):
	OpaqueRef = None
	for vm in  getall_vms(xen_server = xen_server,session = session):
		fields = get_vm_records(xen_server = xen_server,session = session, vm = vm)
		if fields['name_label'] == vmname:
			OpaqueRef = vm
			break
	if not OpaqueRef:
		logerrors("This vm does not exist: " + vmname)
		pass
	return OpaqueRef



#
# Main code
#

# Create and config my logger
logging.basicConfig(level = logging.DEBUG, filename = 'debugerrors.log', format='%(asctime)s %(levelname)s: %(message)s')

## Load values from sys.argv
if not len(sys.argv) == 4:
	logging.debug("Params error! Use: " + sys.argv(0) + " <IP Server> <root password> <vm name>")
	exit()

server   = sys.argv[1]
password = sys.argv[2]
vmname   = sys.argv[3]
protocol = "https"
port     = "443"
user     = "root"
url      = protocol + "://" + server + ":" + port
xen      = xmlrpclib.Server(url)

try:
	session  = login(xen_server = xen, user = user, password = password)
	vmOpaqueRef = getvm_pername(xen_server = xen, session = session, vmname = vmname)
	print count_vm_vbds(xen_server = xen, session = session, vm = vmOpaqueRef)
except:
	# -1 seems that an error has ocurred.
	print "-1"
	exit()

## Close your session
logout(session = session)

exit()
