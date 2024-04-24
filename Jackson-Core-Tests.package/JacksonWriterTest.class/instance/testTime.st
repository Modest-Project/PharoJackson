tests
testTime
	| time |
	time := Time hour: 6 minute: 30 second: 15.
	self assert: (self serialize: time) equals: '{"@type":"Time","@id":1,"seconds":23415,"nanos":0}'.
	time := Time hour: 6 minute: 30 second: 15 nanoSecond: 123.
	self assert: (self serialize: time) equals: '{"@type":"Time","@id":2,"seconds":23415,"nanos":123}'