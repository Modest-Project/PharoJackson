Class {
	#name : #JacksonWriterTest,
	#superclass : #STONWriterTest,
	#instVars : [
		'writer'
	],
	#category : #'Jackson-Core-Tests'
}

{ #category : #private }
JacksonWriterTest >> serialize: anObject [
	^ String streamContents: [ :stream |
		writer
			on: stream;
			nextPut: anObject ]
]

{ #category : #private }
JacksonWriterTest >> serializeAsciiOnly: anObject [
	^ String streamContents: [ :stream |
		JacksonWriter new
			on: stream;
			asciiOnly: true;
			nextPut: anObject ]
]

{ #category : #private }
JacksonWriterTest >> serializeJson: anObject [
	^ String streamContents: [ :stream |
		JacksonWriter new
			on: stream;
			nextPut: anObject ]
]

{ #category : #private }
JacksonWriterTest >> serializePretty: anObject [
	^ String streamContents: [ :stream |
		JacksonWriter new
			on: stream;
			prettyPrint: true;
			nextPut: anObject ]
]

{ #category : #running }
JacksonWriterTest >> setUp [
	super setUp.

	"Put here a common initialization logic for tests"
	writer := JacksonWriter new
]

{ #category : #tests }
JacksonWriterTest >> testArray [
	| array |
	array := (Array new: 5)
		at: 1 put: 1;
		at: 3 put: 3;
		yourself.
	self assert: (self serialize: array) equals: '[1,null,3,null,null]'.
	self assert: (self serialize: Array new) equals: '[]'
]

{ #category : #tests }
JacksonWriterTest >> testArrayWhenReference [
	| array |
	array := (Array new: 5)
		at: 1 put: 1;
		at: 3 put: 3;
		yourself.
	array at: 5 put: array.
	self assert: (self serialize: array) equals: '[1,null,3,null,{"@ref":1}]'.
]

{ #category : #tests }
JacksonWriterTest >> testAssociation [
	
	self assert: (self serialize: #bar -> 2) equals: '{"@type":"Association","@id":1,"key":"bar","value":2}'.
	self assert: (self serialize: 'foo bar' -> #ok) equals: '{"@type":"Association","@id":2,"key":"foo bar","value":"ok"}'.
	self assert: (self serialize: 123 -> 456) equals: '{"@type":"Association","@id":3,"key":123,"value":456}'.
	self assert: (self serialize: (OrderedCollection new) -> 1) equals: '{"@type":"Association","@id":4,"key":{"@type":"OrderedCollection","@id":5,"array":[null,null,null,null,null,null,null,null,null,null],"firstIndex":1,"lastIndex":0},"value":1}'
]

{ #category : #tests }
JacksonWriterTest >> testBag [
	self
		assert: (self serialize: (Bag withAll: #(a a)))
		equals: '{"@type":"Bag","@id":1,"contents":{"@id":2,"a":2}}'.
	self
		assert: (self serialize: Bag new)
		equals: '{"@type":"Bag","@id":3,"contents":{"@id":4}}'
]

{ #category : #tests }
JacksonWriterTest >> testByteArray [
	self assert: (self serialize: #(1 2 15) asByteArray) equals: '"01020f"'
]

{ #category : #tests }
JacksonWriterTest >> testColor [

	| red |
	self skip.
	red := self serialize: Color red.
	self assert:
		('{"@type":"Color","@id":1,"rgb":1072693248,"cachedDepth":32,"cachedBitPattern":"ffff0000","alpha":255}'
			 includesSubstring: red).
	self
		assert: (self serialize: (Color red copy setAlpha: 0.4))
		equals:
		'{"@type":"Color","@id":2,"rgb":1072693248,"cachedDepth":32,"cachedBitPattern":"ffff0000","alpha":102}'.
	self
		assert: (self serialize: Color red lighter lighter)
		equals: '{"@type":"Color","@id":3,"rgb":1072756798,"alpha":255}'
]

{ #category : #tests }
JacksonWriterTest >> testDate [
	| date |
	date := (Date year: 2012 month: 1 day: 1) translateToUTC.
	self assert: (self serialize: date) equals: '{"@type":"Date","@id":1,"start":{"@type":"DateAndTime","@id":2,"seconds":0,"offset":{"@type":"Duration","@id":3,"nanos":0,"seconds":0},"julianDayNumber":2455928,"nanos":0},"duration":{"@type":"Duration","@id":4,"nanos":0,"seconds":86400}}'.
	date := (Date year: 2012 month: 1 day: 1) translateTo: 1 hour.
	self assert: (self serialize: date) equals: '{"@type":"Date","@id":5,"start":{"@type":"DateAndTime","@id":6,"seconds":82800,"offset":{"@type":"Duration","@id":7,"nanos":0,"seconds":3600},"julianDayNumber":2455927,"nanos":0},"duration":{"@type":"Duration","@id":8,"nanos":0,"seconds":86400}}'
]

{ #category : #tests }
JacksonWriterTest >> testDateAndTime [
	| dateAndTime |
	dateAndTime := DateAndTime
		year: 2012
		month: 1
		day: 1
		hour: 6
		minute: 30
		second: 15
		offset: 1 hour.
	self assert: (self serialize: dateAndTime) equals: '{"@type":"DateAndTime","@id":1,"seconds":19815,"offset":{"@type":"Duration","@id":2,"nanos":0,"seconds":3600},"julianDayNumber":2455928,"nanos":0}'
]

{ #category : #tests }
JacksonWriterTest >> testDictionary [
	| collection |
	collection := STON mapClass new
		at: 1 put: 1;
		at: 2 put: 2;
		yourself.
	self assert: (self serialize: collection) equals: '{"@id":1,1:1,2:2}'.
	self assert: (self serialize: STON mapClass new) equals: '{"@id":2}'
]

{ #category : #tests }
JacksonWriterTest >> testDictionaryWithComplexKeys [
	| collection |
	collection := STON mapClass new at: true put: 1; at: #(foo) put: 2; yourself.
	self assert: (self serialize: collection) equals: '{"@id":1,["foo"]:2,true:1}'
]

{ #category : #tests }
JacksonWriterTest >> testId [

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
]

{ #category : #tests }
JacksonWriterTest >> testIdWhenNestedReference [

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
]

{ #category : #tests }
JacksonWriterTest >> testIdWhenReference [

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
]

{ #category : #tests }
JacksonWriterTest >> testList [
	self assert: (self serialize: (STON listClass withAll: #(1 2 3))) equals: '[1,2,3]'.
	self assert: (self serialize: STON listClass new) equals: '[]'.
	self assert: (self serialize: (STON listClass withAll: {1 . -1 . 0 . #foo . 'a b c' . true . false . nil})) equals: '[1,-1,0,"foo","a b c",true,false,null]'
]

{ #category : #tests }
JacksonWriterTest >> testMap [
	| map map2|
	(map := STON mapClass new)
		at: #foo put: 1;
		at: #bar put: 2;
		at: 5 put: 0.
	map2 := STON mapClass new.
	self assert: (self serialize: map) equals: '{"@id":1,5:0,"foo":1,"bar":2}'.
	self assert: (self serialize: map2) equals: '{"@id":2}'.
	map removeAll.
	map at: 'foo bar' put: #ok.
	self assert: (self serialize: map) equals: '{"@ref":1}'.
	map removeAll.
	map at: 123 put: 456.
	self assert: (self serialize: map2) equals: '{"@ref":2}'
]

{ #category : #tests }
JacksonWriterTest >> testMimeType [
	self
		assert: (self serialize: ZnMimeType applicationJson)
		equals: '{"@type":"ZnMimeType","@id":1,"main":"application","sub":"json"}'.
	self
		assert: (self serialize: ZnMimeType textPlain)
		equals: '{"@type":"ZnMimeType","@id":2,"main":"text","sub":"plain","parameters":{"@id":3,"charset":"utf-8"}}'
]

{ #category : #tests }
JacksonWriterTest >> testNil [
	self assert: (self serialize: nil) equals: 'null'
]

{ #category : #tests }
JacksonWriterTest >> testOrderedCollection [
	| collection |
	collection := OrderedCollection with: 1 with: 2 with: 3.
	self assert: (self serialize: collection) equals: '{"@type":"OrderedCollection","@id":1,"array":[1,2,3,null,null,null,null,null,null,null],"firstIndex":1,"lastIndex":3}'.
	self assert: (self serialize: OrderedCollection new) equals: '{"@type":"OrderedCollection","@id":3,"array":[null,null,null,null,null,null,null,null,null,null],"firstIndex":1,"lastIndex":0}'
]

{ #category : #tests }
JacksonWriterTest >> testPoint [
	self assert: (self serialize: 1 @ 2) equals: '{"@type":"Point","@id":1,"x":1,"y":2}'
]

{ #category : #tests }
JacksonWriterTest >> testReferenceCycle [
	| array |
	array := STON listClass with: 1 with: nil.
	array at: 2 put: array.
	self assert: (self serialize: array) equals: '[1,{"@ref":1}]'
]

{ #category : #tests }
JacksonWriterTest >> testReferenceSharing [
	| array one |
	one := {#one}.
	array := STON listClass with: one with: one with: one.
	self assert: (self serialize: array) equals: '[["one"],{"@ref":2},{"@ref":2}]'
]

{ #category : #tests }
JacksonWriterTest >> testRestrictedClassesInJsonMode [

]

{ #category : #tests }
JacksonWriterTest >> testScaledDecimal [
	self assert: (self serialize: 1/3s2) equals: '1/3s2'.
	self assert: (self serialize: -1/3s2) equals: '-1/3s2'.
	self assert: (self serialize: 1/3s10) equals: '1/3s10'.
	self assert: (self serialize: -1/3s10) equals: '-1/3s10'
]

{ #category : #tests }
JacksonWriterTest >> testString [
	| string |
	self assert: (self serialize: 'foo') equals: '"foo"'.
	self assert: (self serialize: 'FOO') equals: '"FOO"'.
	self assert: (self serializeAsciiOnly: 'élève en Français') equals: '"\u00E9l\u00E8ve en Fran\u00E7ais"'.
	self assert: (self serialize: 'élève en Français') equals: '"élève en Français"'.
	string := String withAll: {$" . $' . $\ . $/ . Character tab . Character cr . Character lf . Character newPage . Character backspace}.
	self assert: (self serialize: string) equals: '""''\\/\t\r\n\f\b"'
]

{ #category : #tests }
JacksonWriterTest >> testSymbol [
	self assert: (self serialize: #foo) equals: '"foo"'.
	self assert: (self serialize: #FOO) equals: '"FOO"'.
	self assert: (self serialize: #bytes) equals: '"bytes"'.
	self assert: (self serialize: #'foo.bar') equals: '"foo.bar"'.
	self assert: (self serialize: #'foo-bar') equals: '"foo-bar"'.
	self assert: (self serialize: #foo_bar) equals: '"foo_bar"'.
	self assert: (self serialize: #'foo/bar') equals: '"foo/bar"'.
	self assert: (self serialize: #'foo bar') equals: '"foo bar"'.
	self assert: (self serialize: #foo123) equals: '"foo123"'
]

{ #category : #tests }
JacksonWriterTest >> testTime [
	| time |
	time := Time hour: 6 minute: 30 second: 15.
	self assert: (self serialize: time) equals: '{"@type":"Time","@id":1,"seconds":23415,"nanos":0}'.
	time := Time hour: 6 minute: 30 second: 15 nanoSecond: 123.
	self assert: (self serialize: time) equals: '{"@type":"Time","@id":2,"seconds":23415,"nanos":123}'
]

{ #category : #tests }
JacksonWriterTest >> testURL [
	self
		assert: (self serialize: 'https://pharo.org/files/pharo.png' asUrl)
		equals: '{"@type":"ZnUrl","@id":1,"scheme":"https","host":"pharo.org","segments":{"@type":"OrderedCollection","@id":2,"array":["files","pharo.png",null,null,null,null,null,null,null,null],"firstIndex":1,"lastIndex":2}}'.
	self
		assert: (self serialize: 'mailto:sven@stfx.eu' asUrl)
		equals: '{"@type":"ZnUrl","@id":4,"scheme":"mailto","host":"stfx.eu","username":"sven"}'.
	self
		assert: (self serialize: 'file:///var/log/system.log' asUrl)
		equals: '{"@type":"ZnUrl","@id":5,"scheme":"file","segments":{"@type":"OrderedCollection","@id":6,"array":["var","log","system.log",null,null,null,null,null,null,null],"firstIndex":1,"lastIndex":3}}'.
	self
		assert: (self serialize: 'scheme://user:password@host:123/var/log/system.log?foo=1&bar#frag' asUrl)
		equals: '{"@type":"ZnUrl","@id":8,"scheme":"scheme","host":"host","port":123,"segments":{"@type":"OrderedCollection","@id":9,"array":["var","log","system.log",null,null,null,null,null,null,null],"firstIndex":1,"lastIndex":3},"query":{"@id":10,"foo":"1","bar":null},"fragment":"frag","username":"user","password":"password"}'
]

{ #category : #tests }
JacksonWriterTest >> testUser [
	| user |
	(user := STONTestUser new)
		username: 'john@foo.com';
		password: 'secret1'.
	self
		assert: (self serialize: user)
		equals: '{"@type":"STONTestUser","@id":1,"username":"john@foo.com","password":"secret1","enabled":true}'
]

{ #category : #tests }
JacksonWriterTest >> testUser2 [
	| user |
	(user := STONTestUser2 new)
		username: 'john@foo.com';
		password: 'secret1'.
	self
		assert: (self serialize: user)
		equals: '{"@type":"STONTestUser2","@id":1,"username":"john@foo.com","password":"secret1","enabled":true}'
]

{ #category : #tests }
JacksonWriterTest >> testUser3Nil [
	| user |
	user := STONTestUser3 new.
	self
		assert: (self serialize: user)
		equals: '{"@type":"STONTestUser3","@id":1,"username":null,"password":null,"enabled":true}'
]

{ #category : #tests }
JacksonWriterTest >> testUserNil [
	| user |
	user := STONTestUser new.
	self assert: (self serialize: user) equals: '{"@type":"STONTestUser","@id":1,"enabled":true}'
]
