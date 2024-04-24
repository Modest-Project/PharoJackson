tests
testId

	| user |
	(user := STONTestUser new)
		username: 'john@foo.com';
		password: 'secret1'.
	self
		assert: (self serialize: user)
		equals:
		'{"@type":"STONTestUser","@id":1,"username":"john@foo.com","password":"secret1","enabled":true}'.
	(user := STONTestUser new)
		username: 'john2@foo.com';
		password: 'secret2'.
	self
		assert: (self serialize: user)
		equals:
		'{"@type":"STONTestUser","@id":2,"username":"john2@foo.com","password":"secret2","enabled":true}'