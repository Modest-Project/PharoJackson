private
serializeJson: anObject
	^ String streamContents: [ :stream |
		JacksonWriter new
			on: stream;
			nextPut: anObject ]