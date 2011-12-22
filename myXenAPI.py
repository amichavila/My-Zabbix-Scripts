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

def login(xen_server, user, password):
	login    = xen_server.session.login_with_password(user, password)
	check_response(response = login)
	session  = login['Value']
	return session

def logout(session):
	xen.session.logout(session)

def check_response(response):
	if response['Status'] == "Failure":
		print "An error has ocurred:", login ['ErrorDescription']
		exit()
	if not response['Status'] == "Success":
		print "An error has ocurred: Please report this error..."
		exit()
	if not response.has_key('Value'):
		print "I can't found 'Value' key in the response disctionary..."
		exit()

def getall_vms(xen_server, session):
	allvms = xen_server.VM.get_all(session)
	check_response(response = allvms)
	return allvms['Value']

##########
## Not used yet
#
#def getall_vms_records(xen_server, session):
#	allvms_records = xen_server.VM.get_all_records(session)
#	check_response(response = allvms_records)
#	return allvms_records['Value']

def get_vm_records(xen_server, session, vm):
	records = xen_server.VM.get_record(session, vm)
	check_response(response = records)
	return records['Value']

def countvbds_allvms(xen_server, session, state=None):
	for vm in  getall_vms(xen_server = xen_server,session = session):
		fields = get_vm_records(xen_server = xen_server,session = session, vm = vm)
		if state == "Running":
			if fields['power_state'] == "Running":
				print fields['name_label'], fields['VBDs']
				#print "VM name: {name} \tNumber of vbds: {vbds}".format(name = fields['name_label'], vbds = len(fields['VBDs']))
		else:
			print "VM name: {name} \tNumber of vbds: {vbds}".format(name = fields['name_label'], vbds = len(fields['VBDs']))

def getvm_pername(xen_server, session, vmname):
	OpaqueRef = None
	for vm in  getall_vms(xen_server = xen_server,session = session):
		fields = get_vm_records(xen_server = xen_server,session = session, vm = vm)
		if fields['name_label'] == vmname:
			OpaqueRef = vm
	return OpaqueRef



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
#countvbds_allvms(xen_server = xen, session = session, state = "Running")
print getvm_pername(xen_server = xen, session = session, vmname = "myvmname")


## Close your session
logout(session = session)

exit()
