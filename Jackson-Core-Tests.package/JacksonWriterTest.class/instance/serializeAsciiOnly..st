private
serializeAsciiOnly: anObject
	^ String streamContents: [ :stream |
		JacksonWriter new
			on: stream;
			asciiOnly: true;
			nextPut: anObject ]