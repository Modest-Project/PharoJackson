tests
testPoint
	self assert: (self serialize: 1 @ 2) equals: '{"@type":"Point","@id":1,"x":1,"y":2}'