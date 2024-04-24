tests
testBag
	self
		assert: (self serialize: (Bag withAll: #(a a)))
		equals: '{"@type":"Bag","@id":1,"contents":{"@id":2,"a":2}}'.
	self
		assert: (self serialize: Bag new)
		equals: '{"@type":"Bag","@id":3,"contents":{"@id":4}}'