tests
testArrayWhenReference
	| array |
	array := (Array new: 5)
		at: 1 put: 1;
		at: 3 put: 3;
		yourself.
	array at: 5 put: array.
	self assert: (self serialize: array) equals: '[1,null,3,null,{"@ref":1}]'.