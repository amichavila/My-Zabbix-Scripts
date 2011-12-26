#!/usr/bin/env python

#
# This is my first Xen API.
# lucho -The black hawk- <luislopez72@gmail.com>
#

#.................................................................................................
# Notes for me:
#		* Considerar el uso de un archivo como cache para reducir pedidos al server.
#		* Si se implementa la anterior, considerar una variable booleana para cachear o no.
#.................................................................................................

import xmlrpclib

#
# Functions
#

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
		print "An error has ocurred:", response['ErrorDescription']
		exit()
	if not response['Status'] == "Success":
		print "An error has ocurred: Please report this error..."
		exit()
	if not response.has_key('Value'):
		print "I can't found 'Value' key in the response dictionary..."
		exit()

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
		print "This vm does not exist:", vmname
		exit()
	return OpaqueRef



## Not used...
#
# def getall_vms_records(xen_server, session):
#	allvms_records = xen_server.VM.get_all_records(session)
#	check_response(response = allvms_records)
#	return allvms_records['Value']

## Not used...
# This function is used to count all VBDs grouped by vm name. Only running vms are counted.
# def countvbds_allvms(xen_server, session):
#	vms_vbds = {}
#	for vm in  getall_vms(xen_server = xen_server,session = session):
#		fields = get_vm_records(xen_server = xen_server,session = session, vm = vm)
#		if fields['power_state'] == "Running":
#			vms_vbds[fields['name_label']] = len(fields['VBDs']))
#	return vms_vbds


#
# Main code
#

protocol = "https"
server   = "A.B.C.D"
port     = "443"
user     = "root"
password = "mysecretpassword"
url      = protocol + "://" + server + ":" + port
xen      = xmlrpclib.Server(url)


#
# Call your functions here
#

session  = login(xen_server = xen, user = user, password = password)
vmOpaqueRef = getvm_pername(xen_server = xen, session = session, vmname = "abc0gw")
print vmOpaqueRef
print count_vm_vbds(xen_server = xen, session = session, vm = vmOpaqueRef)


## Close your session
logout(session = session)

exit()
