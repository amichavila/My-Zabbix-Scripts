from scrapy.contrib.exporter import PickleItemExporter
import socket

class SocketExportPipeline(object):
	def __init__ (self, IP, Port):
		self.IP = IP
		self.Port = Port
		self.filepath = "/tmp/pickler.dat"
		self.socket = socket.socket()

	def spider_opened (self):
		self.file = open(self.filepath, "w")
		self.socket.connect((self.IP, self.Port))
		self.pickler = PickleItemExporter(self.file)
		self.pickler.start_exporting()

	def process_item (self, item):
		if item:
			self.pickler.export_item(item)

	def spider_closed():
		self.file.close()
		pickledfile = open(self.filepath, "r")
		for line in pickledfile:
			self.socket.send(line)
		self.socket.close()
		pickledfile.close()
