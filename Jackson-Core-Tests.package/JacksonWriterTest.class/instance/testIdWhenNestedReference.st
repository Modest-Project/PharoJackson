tests
testIdWhenNestedReference

	| user array |
	(user := STONTestUser new)
		username: 'john@foo.com';
		password: 'secret1'.
	self
		assert: (self serialize: user)
		equals:
		'{"@type":"STONTestUser","@id":1,"username":"john@foo.com","password":"secret1","enabled":true}'.
	array := (Array new: 5)
		         at: 1 put: user;
		         at: 4 put: user;
		         yourself.
	array at: 3 put: array.
	self
		assert: (self serialize: array)
		equals: '[{"@ref":1},null,{"@ref":2},{"@ref":1},null]'