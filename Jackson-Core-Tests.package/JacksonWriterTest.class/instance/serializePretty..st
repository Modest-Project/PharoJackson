private
serializePretty: anObject
	^ String streamContents: [ :stream |
		JacksonWriter new
			on: stream;
			prettyPrint: true;
			nextPut: anObject ]