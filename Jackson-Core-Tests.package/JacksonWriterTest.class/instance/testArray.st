tests
testArray
	| array |
	array := (Array new: 5)
		at: 1 put: 1;
		at: 3 put: 3;
		yourself.
	self assert: (self serialize: array) equals: '[1,null,3,null,null]'.
	self assert: (self serialize: Array new) equals: '[]'