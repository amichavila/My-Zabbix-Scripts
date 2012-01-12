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

class XenAPI:

	def __init__(self, server, protocol, port, user, password):
		self.server   = server
		self.protocol = protocol
		self.port     = port
		self.user     = user
		self.password = password
		self.url      = self.protocol + "://" + self.server + ":" + self.port
		self.xen      = xmlrpclib.Server(self.url)
		self.session  = None


	# This function is used to login and it returns the session id.
	def login(self):
		login    = self.xen.session.login_with_password(self.user, self.password)
		self.session  = login['Value']

	# This function is used to logout or close the session.
	def logout(self):
		self.xen.session.logout(self.session)

	# This function is used to get only 'OpaqueRef' of all vms.
	def getall_vms(self):
		allvms = self.xen.VM.get_all(self.session)
		return allvms['Value']

	# This function is used to get all vm records (information about) where vm is OpaqueRef
	def get_vm_records(self, vm):
		records = self.xen.VM.get_record(self.session, vm)
		return records['Value']

	# This function is used to count VBDs of a specific vm.
	def count_vm_vbds(self, vm):
		vmrecords = self.get_vm_records(vm = vm)
		return len(vmrecords['VBDs'])

	# This function is used to get 'OpaqueRef' by vm name
	def getvm_pername(self, vmname):
		OpaqueRef = None
		for vm in self.getall_vms():
			fields = self.get_vm_records(vm = vm)
			if fields['name_label'] == vmname:
				OpaqueRef = vm
				break
		if OpaqueRef:
			return OpaqueRef
		else:
			exit()



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
	
	## Not used...
	# This function is used to check the xen server response.
	# def check_response(self, response):
	#	if response['Status'] == "Failure":
	#		return False
	#	elif not response.has_key('Value'):
	#		return False
	#	else:
	#		return True

