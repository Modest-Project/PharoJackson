writing
encodeMap: pairs

	| first |
	first := true.
	writeStream nextPut: ${.
	self nextPut: '@id' -> (objects size).

	pairs isEmpty
		ifTrue: [ self prettyPrintSpace ]
		ifFalse: [
			self mapElementSeparator.
			self indentedDo: [
				self newlineIndent.
				pairs keysAndValuesDo: [ :key :value |
					first
						ifTrue: [ first := false ]
						ifFalse: [ self mapElementSeparator ].
					self encodeKey: key asString value: value ] ].
			self newlineIndent ].
	writeStream nextPut: $}