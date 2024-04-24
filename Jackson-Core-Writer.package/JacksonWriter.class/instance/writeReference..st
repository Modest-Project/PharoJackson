writing
writeReference: index
	writeStream
		nextPutAll: '{"@ref":';
		print: index;
		nextPut: $}