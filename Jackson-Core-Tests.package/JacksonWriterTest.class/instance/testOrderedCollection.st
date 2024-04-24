tests
testOrderedCollection
	| collection |
	collection := OrderedCollection with: 1 with: 2 with: 3.
	self assert: (self serialize: collection) equals: '{"@type":"OrderedCollection","@id":1,"array":[1,2,3,null,null,null,null,null,null,null],"firstIndex":1,"lastIndex":3}'.
	self assert: (self serialize: OrderedCollection new) equals: '{"@type":"OrderedCollection","@id":3,"array":[null,null,null,null,null,null,null,null,null,null],"firstIndex":1,"lastIndex":0}'