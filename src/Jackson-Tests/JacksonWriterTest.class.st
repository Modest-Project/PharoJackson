Class {
	#name : 'JacksonWriterTest',
	#superclass : 'STONWriterTest',
	#instVars : [
		'writer'
	],
	#category : 'Jackson-Tests',
	#package : 'Jackson-Tests'
}

{ #category : 'private' }
JacksonWriterTest >> serialize: anObject [

	^ String streamContents: [ :stream |
		  writer
			  on: stream;
			  nextPut: anObject;
			  reset ]
]

{ #category : 'private' }
JacksonWriterTest >> serializeAsciiOnly: anObject [
	^ String streamContents: [ :stream |
		JacksonWriter new
			on: stream;
			asciiOnly: true;
			nextPut: anObject ]
]

{ #category : 'private' }
JacksonWriterTest >> serializeJson: anObject [
	^ String streamContents: [ :stream |
		JacksonWriter new
			on: stream;
			nextPut: anObject ]
]

{ #category : 'private' }
JacksonWriterTest >> serializePretty: anObject [
	^ String streamContents: [ :stream |
		JacksonWriter new
			on: stream;
			prettyPrint: true;
			nextPut: anObject ]
]

{ #category : 'running' }
JacksonWriterTest >> setUp [

	super setUp.
	writer := JacksonWriter new
]

{ #category : 'tests' }
JacksonWriterTest >> testArray [

	| array array2 |
	array := (Array new: 5)
		         at: 1 put: 1;
		         at: 3 put: 3;
		         yourself.
	array2 := (Array new: 2)
		          at: 1 put: 1;
		          yourself.
	self assert: (self serialize: array) equals: '[1,1,null,3,null,null]'. "the first element is the id"
	self assert: (self serialize: Array new) equals: '[1]'.
	self
		assert: (self serialize: (Dictionary new
					  at: 1 put: array2;
					  yourself))
		equals:
		'{"@type":"Dictionary","@":[{"@type":"Association","key":1,"value":[3,1,null],"@id":2}],"@id":1}'
]

{ #category : 'tests' }
JacksonWriterTest >> testArrayWhenReference [
	| array |
	array := (Array new: 5)
		at: 1 put: 1;
		at: 3 put: 3;
		yourself.
	array at: 5 put: array.
	self assert: (self serialize: array) equals: '[1,1,null,3,null,{"@ref":1}]'.
]

{ #category : 'tests' }
JacksonWriterTest >> testAssociation [

	self
		assert: (self serialize: #bar -> 2)
		equals:
		'{"@type":"Association","key":{"@type":"ByteSymbol","value":"bar","@id":2},"value":2,"@id":1}'.
	self
		assert: (self serialize: 'foo bar' -> #ok)
		equals:
		'{"@type":"Association","key":"foo bar","value":{"@type":"ByteSymbol","value":"ok","@id":2},"@id":1}'.
	self
		assert: (self serialize: 123 -> 456)
		equals: '{"@type":"Association","key":123,"value":456,"@id":1}'.
	self
		assert: (self serialize: OrderedCollection new -> 1)
		equals:
		'{"@type":"Association","key":{"@type":"OrderedCollection","@":[],"@id":2},"value":1,"@id":1}'
]

{ #category : 'tests' }
JacksonWriterTest >> testBag [

	self
		assert: (self serialize: (Bag withAll: #( a a )))
		equals:
		'{"@type":"Bag","contents":{"@type":"Dictionary","@":[{"@type":"Association","key":{"@type":"ByteSymbol","value":"a","@id":4},"value":2,"@id":3}],"@id":2},"@id":1}'.
	self
		assert: (self serialize: Bag new)
		equals:
		'{"@type":"Bag","contents":{"@type":"Dictionary","@":[],"@id":2},"@id":1}'
]

{ #category : 'tests' }
JacksonWriterTest >> testBlock [

	| c |
	self
		assert: (self serialize: [  ])
		equals:
		'{"@type":"ConstantBlockClosure","compiledBlock":{"@type":"CompiledBlock","source":"[  ]","@id":2},"numArgs":0,"@id":1}'.

	self
		assert: (self serialize: [ "foo" 'bar' ])
		equals:
		'{"@type":"ConstantBlockClosure","compiledBlock":{"@type":"CompiledBlock","source":"[ \"foo\" ''bar'' ]","@id":2},"numArgs":0,"@id":1}'.

	self
		assert: (self serialize: [ :i | [ i ] ])
		equals:
		'{"@type":"FullBlockClosure","compiledBlock":{"@type":"CompiledBlock","source":"[ :i | [ i ] ]","@id":2},"numArgs":1,"@id":1}'.

	c := 10.
	self
		assert: (self serialize: [ :a :b | a + b - c ])
		equals:
		'{"@type":"FullBlockClosure","compiledBlock":{"@type":"CompiledBlock","source":"[ :a :b | a + b - c ]","@id":2},"vars":{"c":10},"numArgs":2,"@id":1}'.

	self
		assert: (self serialize: [ :a :b | [ a + b - c ] ])
		equals:
		'{"@type":"FullBlockClosure","compiledBlock":{"@type":"CompiledBlock","source":"[ :a :b | [ a + b - c ] ]","@id":2},"vars":{"c":10},"numArgs":2,"@id":1}'
]

{ #category : 'tests' }
JacksonWriterTest >> testByteArray [

	self
		assert: (self serialize: #( 1 2 15 ) asByteArray)
		equals: '{"@type":"ByteArray","@":[1,2,15],"@id":1}'
]

{ #category : 'tests' }
JacksonWriterTest >> testCharacter [

	self
		assert: (self serialize: $a)
		equals: '{"@type":"Character","value":97}'
]

{ #category : 'tests' }
JacksonWriterTest >> testClass [

	self
		assert: (self serialize: Point)
		equals: '{"@type":"Class","name":"Point"}' "TO DO"
]

{ #category : 'tests' }
JacksonWriterTest >> testColor [

	| red |
	red := self serialize: Color red.
	self assert:
		((red includesSubstring: '"@type":"Color","rgb":1072693248') and:
			 (red includesSubstring: '"alpha":255,"@id":1'))
]

{ #category : 'tests' }
JacksonWriterTest >> testDate [

	| date |
	date := (Date year: 2012 month: 1 day: 1) translateToUTC.
	self
		assert: (self serialize: date)
		equals:
		'{"@type":"Date","start":{"@type":"DateAndTime","seconds":0,"offset":{"@type":"Duration","nanos":0,"seconds":0,"@id":3},"julianDayNumber":2455928,"nanos":0,"@id":2},"duration":{"@type":"Duration","nanos":0,"seconds":86400,"@id":4},"@id":1}'.
	date := (Date year: 2012 month: 1 day: 1) translateTo: 1 hour.
	self
		assert: (self serialize: date)
		equals:
		'{"@type":"Date","start":{"@type":"DateAndTime","seconds":82800,"offset":{"@type":"Duration","nanos":0,"seconds":3600,"@id":3},"julianDayNumber":2455927,"nanos":0,"@id":2},"duration":{"@type":"Duration","nanos":0,"seconds":86400,"@id":4},"@id":1}'
]

{ #category : 'tests' }
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
	self
		assert: (self serialize: dateAndTime)
		equals:
		'{"@type":"DateAndTime","seconds":19815,"offset":{"@type":"Duration","nanos":0,"seconds":3600,"@id":2},"julianDayNumber":2455928,"nanos":0,"@id":1}'
]

{ #category : 'tests' }
JacksonWriterTest >> testDictionary [

	| collection |
	collection := Dictionary new
		              at: 1 put: 2;
		              yourself.
	self
		assert: (self serialize: collection)
		equals:
		'{"@type":"Dictionary","@":[{"@type":"Association","key":1,"value":2,"@id":2}],"@id":1}'.
	self
		assert: (self serialize: STON mapClass new)
		equals: '{"@type":"Dictionary","@":[],"@id":1}'
]

{ #category : 'tests' }
JacksonWriterTest >> testDictionaryWithComplexKeys [

	| collection |
	collection := OrderedDictionary new
		              at: true put: 1;
		              at: #( foo ) put: 2;
		              yourself.
	self
		assert: (self serialize: collection)
		equals:
		'{"@type":"OrderedDictionary","@":[{"@type":"Association","key":true,"value":1,"@id":2},{"@type":"Association","key":[4,{"@type":"ByteSymbol","value":"foo","@id":5}],"value":2,"@id":3}],"@id":1}'
]

{ #category : 'tests' }
JacksonWriterTest >> testDiskFile [

	self
		assert: (self serialize: '/test/foo.txt' asFileReference)
		equals: '{"@type":"FileReference","path":"/test/foo.txt","@id":1}'.
	self
		assert: (self serialize: '/tmp/foo.txt' asFileReference)
		equals: '{"@type":"FileReference","path":"/tmp/foo.txt","@id":1}'.
	self
		assert: (self serialize: 'tmp/foo.txt' asFileReference)
		equals: '{"@type":"FileReference","path":"tmp/foo.txt","@id":1}'.
	self
		assert: (self serialize: '/tmp' asFileReference)
		equals: '{"@type":"FileReference","path":"/tmp","@id":1}'.
	self
		assert: (self serialize: '/tmp/' asFileReference)
		equals: '{"@type":"FileReference","path":"/tmp","@id":1}'
]

{ #category : 'tests' }
JacksonWriterTest >> testFloat [
	self assert: (self serialize: 1.5) equals: '1.5'.
	self assert: (self serialize: 0.0) equals: '0.0'.
	self assert: (self serialize: -1.5) equals: '-1.5'.
	self assert: ((self serialize: Float pi) beginsWith: '3.14159').
	self assert: ((self serialize: (1 / 3) asFloat) beginsWith: '0.333').
	self assert: (self serialize: (10 raisedTo: 100) asFloat) equals: '1.0e100'.
	self assert: (self serialize: (10 raisedTo: -50) asFloat) equals: '1.0e-50'.
	self assert: (self serialize: (10 raisedTo: -50) asFloat negated) equals: '-1.0e-50'.
	self assert: (self serialize: Float nan) equals: '{"@type":"Float","value":"nan"}'.
	self assert: (self serialize: Float infinity) equals: '{"@type":"Float","value":"infinity"}'.
	self assert: (self serialize: Float negativeInfinity) equals: '{"@type":"Float","value":"negativeInfinity"}'
]

{ #category : 'tests' }
JacksonWriterTest >> testFraction [

	self
		assert: (self serialize: 1 / 3)
		equals: '{"@type":"Fraction","numerator":1,"denominator":3,"@id":1}'.
	self
		assert: (self serialize: -8 / 5)
		equals:
		'{"@type":"Fraction","numerator":-8,"denominator":5,"@id":1}'
]

{ #category : 'tests' }
JacksonWriterTest >> testId [

	| user |
	(user := STONTestUser new)
		username: 'john@foo.com';
		password: 'secret1'.
	self
		assert: (self serialize: user)
		equals:
		'{"@type":"STONTestUser","username":"john@foo.com","password":"secret1","enabled":true,"@id":1}'.
	(user := STONTestUser new)
		username: 'john2@foo.com';
		password: 'secret2'.
	self
		assert: (self serialize: user)
		equals:
		'{"@type":"STONTestUser","username":"john2@foo.com","password":"secret2","enabled":true,"@id":1}'
]

{ #category : 'tests' }
JacksonWriterTest >> testIdWhenNestedReference [

	| user array |
	(user := STONTestUser new)
		username: 'john@foo.com';
		password: 'secret1'.
	self
		assert: (self serialize: user)
		equals:
		'{"@type":"STONTestUser","username":"john@foo.com","password":"secret1","enabled":true,"@id":1}'.
	array := (Array new: 5)
		         at: 1 put: user;
		         at: 4 put: user;
		         yourself.
	array at: 3 put: array.
	self
		assert: (self serialize: array)
		equals:
		'[1,{"@type":"STONTestUser","username":"john@foo.com","password":"secret1","enabled":true,"@id":2},null,{"@ref":1},{"@ref":2},null]'
]

{ #category : 'tests' }
JacksonWriterTest >> testIdWhenReference [

	| user |
	(user := STONTestUser new)
		username: 'john@foo.com';
		password: 'secret1'.
	self
		assert: (self serialize: {
					 user.
					 user })
		equals:
		'[1,{"@type":"STONTestUser","username":"john@foo.com","password":"secret1","enabled":true,"@id":2},{"@ref":2}]'
]

{ #category : 'tests' }
JacksonWriterTest >> testIdentityDictionary [

	| collection |
	collection := IdentityDictionary new
		              at: 1 put: 1;
		              at: 2 put: 2;
		              yourself.
	self
		assert: (self serialize: collection)
		equals:
		'{"@type":"IdentityDictionary","tally":2,"array":[2,{"@type":"Association","key":1,"value":1,"@id":3},{"@type":"Association","key":2,"value":2,"@id":4},null,null,null],"@id":1}'.
	self
		assert: (self serialize: IdentityDictionary new)
		equals:
		'{"@type":"IdentityDictionary","tally":0,"array":[2,null,null,null,null,null],"@id":1}'
]

{ #category : 'tests' }
JacksonWriterTest >> testLinkedList [

	| collection |
	self
		assert: (self serialize: LinkedList new)
		equals:
		'{"@type":"LinkedList","firstLink":null,"lastLink":null,"@id":1}'.

	collection := LinkedList
		              with: 1
		              with: 2
		              with: 3
		              with: nil.
	self
		assert: (self serialize: collection)
		equals:
		'{"@type":"LinkedList","firstLink":{"@type":"ValueLink","nextLink":{"@type":"ValueLink","nextLink":{"@type":"ValueLink","nextLink":{"@type":"ValueLink","nextLink":null,"value":null,"@id":5},"value":3,"@id":4},"value":2,"@id":3},"value":1,"@id":2},"lastLink":{"@ref":5},"@id":1}'
]

{ #category : 'tests' }
JacksonWriterTest >> testList [

	self assert: (self serialize: STON listClass new) equals: '[1]'.
	self
		assert: (self serialize: (STON listClass withAll: #( 1 2 3 )))
		equals: '[1,1,2,3]'.
	self
		assert: (self serialize:
				 (STON listClass withAll:
					  { 1. -1. 0. #foo. 'a b c'. true. false. nil }))
		equals:
		'[1,1,-1,0,{"@type":"ByteSymbol","value":"foo","@id":2},"a b c",true,false,null]'
]

{ #category : 'tests' }
JacksonWriterTest >> testMap [

	| map |
	(map := STON mapClass new)
		at: #foo put: 1;
		at: #bar put: 2;
		at: 5 put: 0.
	self
		assert: (self serialize: map)
		equals:
		'{"@type":"Dictionary","@":[{"@type":"Association","key":5,"value":0,"@id":2},{"@type":"Association","key":{"@type":"ByteSymbol","value":"foo","@id":4},"value":1,"@id":3},{"@type":"Association","key":{"@type":"ByteSymbol","value":"bar","@id":6},"value":2,"@id":5}],"@id":1}'.
	map removeAll.
	self
		assert: (self serialize: map)
		equals: '{"@type":"Dictionary","@":[],"@id":1}'.
	map at: 'foo bar' put: #ok.
	self
		assert: (self serialize: map)
		equals:
		'{"@type":"Dictionary","@":[{"@type":"Association","key":"foo bar","value":{"@type":"ByteSymbol","value":"ok","@id":3},"@id":2}],"@id":1}'.
	map removeAll.
	map at: 123 put: 456.
	self
		assert: (self serialize: map)
		equals:
		'{"@type":"Dictionary","@":[{"@type":"Association","key":123,"value":456,"@id":2}],"@id":1}'
]

{ #category : 'tests' }
JacksonWriterTest >> testMimeType [

	self
		assert: (self serialize: ZnMimeType applicationJson)
		equals:
		'{"@type":"ZnMimeType","main":"application","sub":"json","parameters":null,"@id":1}'.
	self
		assert: (self serialize: ZnMimeType textPlain)
		equals:
		'{"@type":"ZnMimeType","main":"text","sub":"plain","parameters":{"@type":"SmallDictionary","keys":[3,"charset",null],"values":[4,"utf-8",null],"size":1,"@id":2},"@id":1}'
]

{ #category : 'tests' }
JacksonWriterTest >> testNil [
	self assert: (self serialize: nil) equals: 'null'
]

{ #category : 'tests' }
JacksonWriterTest >> testObjectWithNoInstVars [

	self
		assert: (self serialize: MockClassWithNoInstVars new)
		equals: '{"@type":"MockClassWithNoInstVars","@id":1}'
]

{ #category : 'tests' }
JacksonWriterTest >> testOrderedCollection [

	| collection |
	collection := OrderedCollection
		              with: 1
		              with: 2
		              with: 3
		              with: nil.
	self
		assert: (self serialize: collection)
		equals: '{"@type":"OrderedCollection","@":[1,2,3,null],"@id":1}'.
	self
		assert: (self serialize: OrderedCollection new)
		equals: '{"@type":"OrderedCollection","@":[],"@id":1}'
]

{ #category : 'tests' }
JacksonWriterTest >> testPoint [

	self
		assert: (self serialize: 1 @ 2)
		equals: '{"@type":"Point","x":1,"y":2,"@id":1}'
]

{ #category : 'tests' }
JacksonWriterTest >> testReferenceCycle [
	| array |
	array := STON listClass with: 1 with: nil.
	array at: 2 put: array.
	self assert: (self serialize: array) equals: '[1,1,{"@ref":1}]'
]

{ #category : 'tests' }
JacksonWriterTest >> testReferenceSharing [

	| array one |
	one := { #one }.
	array := STON listClass with: one with: one with: one.
	self
		assert: (self serialize: array)
		equals:
		'[1,[2,{"@type":"ByteSymbol","value":"one","@id":3}],{"@ref":2},{"@ref":2}]'
]

{ #category : 'tests' }
JacksonWriterTest >> testScaledDecimal [

	self
		assert: (self serialize: 1 / 3s2)
		equals:
		'{"@type":"ScaledDecimal","numerator":1,"denominator":3,"scale":2,"@id":1}'.
	self
		assert: (self serialize: -1 / 3s2)
		equals:
		'{"@type":"ScaledDecimal","numerator":-1,"denominator":3,"scale":2,"@id":1}'.
	self
		assert: (self serialize: 1 / 3s10)
		equals:
		'{"@type":"ScaledDecimal","numerator":1,"denominator":3,"scale":10,"@id":1}'.
	self
		assert: (self serialize: -1 / 3s10)
		equals:
		'{"@type":"ScaledDecimal","numerator":-1,"denominator":3,"scale":10,"@id":1}'
]

{ #category : 'tests' }
JacksonWriterTest >> testSet [

	| collection |
	collection := Set
		              with: 1
		              with: 2
		              with: 3
		              with: nil.
	self
		assert: (self serialize: collection)
		equals: '{"@type":"Set","@":[1,2,3,null],"@id":1}'.
	self
		assert: (self serialize: Set new)
		equals: '{"@type":"Set","@":[],"@id":1}'
]

{ #category : 'tests' }
JacksonWriterTest >> testString [

	| string |
	self assert: (self serialize: 'foo') equals: '"foo"'.
	self assert: (self serialize: 'FOO') equals: '"FOO"'.
	self
		assert: (self serializeAsciiOnly: 'élève en Français')
		equals: '"\u00E9l\u00E8ve en Fran\u00E7ais"'.
	self
		assert: (self serialize: 'élève en Français')
		equals: '"élève en Français"'.
	string := String withAll: {
			          $".
			          $'.
			          $\.
			          $/.
			          Character tab.
			          Character cr.
			          Character lf.
			          Character newPage.
			          Character backspace }.
	self assert: (self serialize: string) equals: '"\"''\\/\t\r\n\f\b"'
]

{ #category : 'tests' }
JacksonWriterTest >> testSymbol [

	self
		assert: (self serialize: #foo)
		equals: '{"@type":"ByteSymbol","value":"foo","@id":1}'.
	self
		assert: (self serialize: #FOO)
		equals: '{"@type":"ByteSymbol","value":"FOO","@id":1}'.
	self
		assert: (self serialize: #bytes)
		equals: '{"@type":"ByteSymbol","value":"bytes","@id":1}'.
	self
		assert: (self serialize: #'foo.bar')
		equals: '{"@type":"ByteSymbol","value":"foo.bar","@id":1}'.
	self
		assert: (self serialize: #'foo-bar')
		equals: '{"@type":"ByteSymbol","value":"foo-bar","@id":1}'.
	self
		assert: (self serialize: #foo_bar)
		equals: '{"@type":"ByteSymbol","value":"foo_bar","@id":1}'.
	self
		assert: (self serialize: #'foo/bar')
		equals: '{"@type":"ByteSymbol","value":"foo/bar","@id":1}'.
	self
		assert: (self serialize: #'foo bar')
		equals: '{"@type":"ByteSymbol","value":"foo bar","@id":1}'.
	self
		assert: (self serialize: #foo123)
		equals: '{"@type":"ByteSymbol","value":"foo123","@id":1}'
]

{ #category : 'tests' }
JacksonWriterTest >> testTime [

	| time |
	time := Time hour: 6 minute: 30 second: 15.
	self
		assert: (self serialize: time)
		equals: '{"@type":"Time","seconds":23415,"nanos":0,"@id":1}'.
	time := Time
		        hour: 6
		        minute: 30
		        second: 15
		        nanoSecond: 123.
	self
		assert: (self serialize: time)
		equals: '{"@type":"Time","seconds":23415,"nanos":123,"@id":1}'
]

{ #category : 'tests' }
JacksonWriterTest >> testURL [

	self
		assert: (self serialize: 'https://pharo.org/files/pharo.png' asUrl)
		equals:
		'{"@type":"ZnUrl","scheme":{"@type":"ByteSymbol","value":"https","@id":2},"host":"pharo.org","port":null,"segments":{"@type":"OrderedCollection","@":["files","pharo.png"],"@id":3},"query":null,"fragment":null,"username":null,"password":null,"@id":1}'.
	self
		assert: (self serialize: 'mailto:sven@stfx.eu' asUrl)
		equals:
		'{"@type":"ZnUrl","scheme":{"@type":"ByteSymbol","value":"mailto","@id":2},"host":"stfx.eu","port":null,"segments":null,"query":null,"fragment":null,"username":"sven","password":null,"@id":1}'.
	self
		assert: (self serialize: 'file:///var/log/system.log' asUrl)
		equals:
		'{"@type":"ZnUrl","scheme":{"@type":"ByteSymbol","value":"file","@id":2},"host":null,"port":null,"segments":{"@type":"OrderedCollection","@":["var","log","system.log"],"@id":3},"query":null,"fragment":null,"username":null,"password":null,"@id":1}'.
	self
		assert: (self serialize:
				 'scheme://user:password@host:123/var/log/system.log?foo=1&bar#frag'
					 asUrl)
		equals:
		'{"@type":"ZnUrl","scheme":{"@type":"ByteSymbol","value":"scheme","@id":2},"host":"host","port":123,"segments":{"@type":"OrderedCollection","@":["var","log","system.log"],"@id":3},"query":{"@type":"ZnMultiValueDictionary","dictionary":{"@type":"Dictionary","@":[{"@type":"Association","key":"bar","value":null,"@id":6},{"@type":"Association","key":"foo","value":"1","@id":7}],"@id":5},"orderedKeys":[8,"foo","bar",null,null,null,null,null,null,null,null],"limit":256,"@id":4},"fragment":"frag","username":"user","password":"password","@id":1}'
]

{ #category : 'tests' }
JacksonWriterTest >> testUser [

	| user |
	(user := STONTestUser new)
		username: 'john@foo.com';
		password: 'secret1'.
	self
		assert: (self serialize: user)
		equals:
		'{"@type":"STONTestUser","username":"john@foo.com","password":"secret1","enabled":true,"@id":1}'
]

{ #category : 'tests' }
JacksonWriterTest >> testUser2 [

	| user |
	(user := STONTestUser2 new)
		username: 'john@foo.com';
		password: 'secret1'.
	self
		assert: (self serialize: user)
		equals:
		'{"@type":"STONTestUser2","username":"john@foo.com","password":"secret1","enabled":true,"@id":1}'
]

{ #category : 'tests' }
JacksonWriterTest >> testUser3Nil [

	| user |
	user := STONTestUser3 new.
	self
		assert: (self serialize: user)
		equals:
		'{"@type":"STONTestUser3","username":null,"password":null,"enabled":true,"@id":1}'
]

{ #category : 'tests' }
JacksonWriterTest >> testUserNil [

	| user |
	user := STONTestUser new.
	self
		assert: (self serialize: user)
		equals:
		'{"@type":"STONTestUser","username":null,"password":null,"enabled":true,"@id":1}'
]

{ #category : 'tests' }
JacksonWriterTest >> testWriteCollectionInnerArray [

	| collection |
	collection := {
		              'lostArrayRefButNotElements'.
		              Object new }.
	self
		assert: (self serialize: {
					 collection.
					 (OrderedCollection new setContents: collection) })
		equals:
		'[1,[2,"lostArrayRefButNotElements",{"@type":"Object","@id":3}],{"@type":"OrderedCollection","@":["lostArrayRefButNotElements",{"@ref":3}],"@id":4}]'
]
