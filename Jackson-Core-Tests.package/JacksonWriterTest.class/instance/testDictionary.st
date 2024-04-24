tests
testDictionary
	| collection |
	collection := STON mapClass new
		at: 1 put: 1;
		at: 2 put: 2;
		yourself.
	self assert: (self serialize: collection) equals: '{"@id":1,"1":1,"2":2}'.
	self assert: (self serialize: STON mapClass new) equals: '{"@id":2}'