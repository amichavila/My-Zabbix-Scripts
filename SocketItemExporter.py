import socket

class SocketItemExporter(object):
	def __init__ (self, IP, Port):
		self.IP = IP
		self.Port = Port
		self.socket = socket.socket()

	def start_exporting (self):
		self.socket.connect((self.IP, self.Port))
		return None

	def export_item (self, item):
		self.socket.send(item)
		return None

	def finish_exporting():
		self.socket.close()
		return None
