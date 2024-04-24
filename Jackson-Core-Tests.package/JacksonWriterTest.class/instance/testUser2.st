tests
testUser2
	| user |
	(user := STONTestUser2 new)
		username: 'john@foo.com';
		password: 'secret1'.
	self
		assert: (self serialize: user)
		equals: '{"@type":"STONTestUser2","@id":1,"username":"john@foo.com","password":"secret1","enabled":true}'