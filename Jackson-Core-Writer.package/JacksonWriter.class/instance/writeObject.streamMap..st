writing
writeObject: object streamMap: block

	self writeObject: object do: [
		| mapWriter |
		mapWriter := STONMapWriter on: self.
		writeStream nextPut: ${.
		self nextPut: '@type' -> object className.
		self mapElementSeparator.
		self nextPut: '@id' -> (objects size).
		self mapElementSeparator.
		self indentedDo: [
			self newlineIndent.
			block value: mapWriter ].
		self newlineIndent.
		writeStream nextPut: $} ]