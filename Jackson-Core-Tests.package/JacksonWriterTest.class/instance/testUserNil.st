tests
testUserNil
	| user |
	user := STONTestUser new.
	self assert: (self serialize: user) equals: '{"@type":"STONTestUser","@id":1,"enabled":true}'