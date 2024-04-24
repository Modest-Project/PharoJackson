tests
testMap
	| map map2|
	(map := STON mapClass new)
		at: #foo put: 1;
		at: #bar put: 2.
	map2 := STON mapClass new.
	self assert: (self serialize: map) equals: '{"@id":1,"foo":1,"bar":2}'.
	self assert: (self serialize: map2) equals: '{"@id":2}'.
	map removeAll.
	map at: 'foo bar' put: #ok.
	self assert: (self serialize: map) equals: '{"@ref":1}'.
	map removeAll.
	map at: 123 put: 456.
	self assert: (self serialize: map2) equals: '{"@ref":2}'