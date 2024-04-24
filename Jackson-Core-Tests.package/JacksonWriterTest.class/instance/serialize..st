private
serialize: anObject
	^ String streamContents: [ :stream |
		writer
			on: stream;
			nextPut: anObject ]