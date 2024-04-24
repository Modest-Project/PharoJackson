private
encodeKey: key value: value

	key isString ifFalse: [
		self error: 'JSON key names in objects must be strings' ].
	self nextPut: key.
	self prettyPrintSpace.
	writeStream nextPut: $:.
	self prettyPrintSpace.
	self nextPut: value