tests
testIdWhenReference

	| user |
	(user := STONTestUser new)
		username: 'john@foo.com';
		password: 'secret1'.
	self
		assert: (self serialize: user)
		equals:
		'{"@type":"STONTestUser","@id":1,"username":"john@foo.com","password":"secret1","enabled":true}'.
	self
		assert: (self serialize: user)
		equals:
		'{"@ref":1}'