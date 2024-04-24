tests
testByteArray
	self assert: (self serialize: #(1 2 15) asByteArray) equals: '"01020f"'