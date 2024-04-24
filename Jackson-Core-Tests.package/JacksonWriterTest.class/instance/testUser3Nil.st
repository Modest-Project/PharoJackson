tests
testUser3Nil
	| user |
	user := STONTestUser3 new.
	self
		assert: (self serialize: user)
		equals: '{"@type":"STONTestUser3","@id":1,"username":null,"password":null,"enabled":true}'