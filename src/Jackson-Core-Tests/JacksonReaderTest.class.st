Class {
	#name : 'JacksonReaderTest',
	#superclass : 'STONWriterTest',
	#instVars : [
		'reader'
	],
	#category : 'Jackson-Core-Tests',
	#package : 'Jackson-Core-Tests'
}

{ #category : 'running' }
JacksonReaderTest >> materialize: aString [

	^ reader
		  on: aString readStream;
		  next
]

{ #category : 'running' }
JacksonReaderTest >> setUp [

	super setUp.
	reader := JacksonReader new
]

{ #category : 'tests' }
JacksonReaderTest >> testArray [

	| array array2 |
	array := (Array new: 5)
		         at: 1 put: 1;
		         at: 3 put: 3;
		         yourself.
	array2 := (Array new: 2)
		          at: 1 put: 1;
		          yourself.
	self
		assert: (self materialize: '[1,1,null,3,null,null]')
		equals: array.
	self assert: (self materialize: '[1]') equals: Array new.
	self
		assert: (self materialize:
				 '{"@type":"Dictionary","@":[{"@type":"Association","key":1,"value":[3,1,null],"@id":2}],"@id":1}')
		equals: (Dictionary new
				 at: 1 put: array2;
				 yourself)
]

{ #category : 'tests' }
JacksonReaderTest >> testArrayWhenReference [

	| array |
	array := (Array new: 5)
		         at: 1 put: 1;
		         at: 3 put: 3;
		         yourself.
	array at: 5 put: array.
	self
		assert: (self materialize: '[1,1,null,3,null,{"@ref":1}]')
		equals: array
]

{ #category : 'tests' }
JacksonReaderTest >> testAssociation [

	self
		assert: (self materialize:
				 '{"@type":"Association","key":{"@type":"ByteSymbol","value":"bar","@id":2},"value":2,"@id":1}')
		equals: #bar -> 2.
	self
		assert: (self materialize:
				 '{"@type":"Association","key":"foo bar","value":{"@type":"ByteSymbol","value":"ok","@id":2},"@id":1}')
		equals: 'foo bar' -> #ok.
	self
		assert: (self materialize:
				 '{"@type":"Association","key":123,"value":456,"@id":1}')
		equals: 123 -> 456.
	self
		assert: (self materialize:
				 '{"@type":"Association","key":{"@type":"OrderedCollection","@":[],"@id":2},"value":1,"@id":1}')
		equals: OrderedCollection new -> 1
]

{ #category : 'tests' }
JacksonReaderTest >> testBag [

	self
		assert: (self materialize:
				 '{"@type":"Bag","contents":{"@type":"Dictionary","@":[{"@type":"Association","key":{"@type":"ByteSymbol","value":"a","@id":4},"value":2,"@id":3}],"@id":2},"@id":1}')
		equals: (Bag withAll: #( a a )).
	self
		assert: (self materialize:
				 '{"@type":"Bag","contents":{"@type":"Dictionary","@":[],"@id":2},"@id":1}')
		equals: Bag new
]

{ #category : 'tests' }
JacksonReaderTest >> testBlock [

	| c |
	self
		assert: (self materialize:
				 '{"@type":"ConstantBlockClosure","compiledBlock":{"@type":"CompiledBlock","source":"[  ]","@id":2},"numArgs":0,"@id":1}')
		equals: [  ].
	self
		assert: (self materialize:
				 '{"@type":"ConstantBlockClosure","compiledBlock":{"@type":"CompiledBlock","source":"[ \"foo\" ''bar'' ]","@id":2},"numArgs":0,"@id":1}')
		equals: [ "foo" 'bar' ].
	self
		assert: (self materialize:
				 '{"@type":"FullBlockClosure","compiledBlock":{"@type":"CompiledBlock","source":"[ :i | [ i ] ]","@id":2},"numArgs":1,"@id":1}')
		equals: [ :i | [ i ] ].
	c := 10.
	self
		assert: (self materialize:
				 '{"@type":"FullBlockClosure","compiledBlock":{"@type":"CompiledBlock","source":"[ :a :b | a + b - c ]","@id":2},"vars":{"c":10},"numArgs":2,"@id":1}')
		equals: [ :a :b | a + b - c ].
	self
		assert: (self materialize:
				 '{"@type":"FullBlockClosure","compiledBlock":{"@type":"CompiledBlock","source":"[ :a :b | [ a + b - c ] ]","@id":2},"vars":{"c":10},"numArgs":2,"@id":1}')
		equals: [ :a :b | [ a + b - c ] ]
]

{ #category : 'tests' }
JacksonReaderTest >> testByteArray [

	self
		assert:
		(self materialize: '{"@type":"ByteArray","@":[1,2,15],"@id":1}')
		equals: #( 1 2 15 ) asByteArray
]

{ #category : 'tests' }
JacksonReaderTest >> testCharacter [

	self
		assert: (self materialize: '{"@type":"Character","value":97}')
		equals: $a
]

{ #category : 'tests' }
JacksonReaderTest >> testClass [

	self
		assert: (self materialize: '{"@type":"Class","name":"Point"}')
		equals: Point
]

{ #category : 'tests' }
JacksonReaderTest >> testColor [

	self
		assert: (self materialize:
				 '{"@type":"Color","rgb":1072693248,"alpha":255,"@id":1}')
		equals: Color red
]

{ #category : 'tests' }
JacksonReaderTest >> testDate [

	| date |
	date := (Date year: 2012 month: 1 day: 1) translateToUTC.
	self
		assert: (self materialize:
				 '{"@type":"Date","start":{"@type":"DateAndTime","seconds":0,"offset":{"@type":"Duration","nanos":0,"seconds":0,"@id":3},"julianDayNumber":2455928,"nanos":0,"@id":2},"duration":{"@type":"Duration","nanos":0,"seconds":86400,"@id":4},"@id":1}')
		equals: date.
	date := (Date year: 2012 month: 1 day: 1) translateTo: 1 hour.
	self
		assert: (self materialize:
				 '{"@type":"Date","start":{"@type":"DateAndTime","seconds":82800,"offset":{"@type":"Duration","nanos":0,"seconds":3600,"@id":3},"julianDayNumber":2455927,"nanos":0,"@id":2},"duration":{"@type":"Duration","nanos":0,"seconds":86400,"@id":4},"@id":1}')
		equals: date
]

{ #category : 'tests' }
JacksonReaderTest >> testDateAndTime [

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
		assert: (self materialize:
				 '{"@type":"DateAndTime","seconds":19815,"offset":{"@type":"Duration","nanos":0,"seconds":3600,"@id":2},"julianDayNumber":2455928,"nanos":0,"@id":1}')
		equals: dateAndTime
]

{ #category : 'tests' }
JacksonReaderTest >> testDictionary [

	| collection |
	collection := Dictionary new
		              at: 1 put: 2;
		              yourself.
	self
		assert: (self materialize:
				 '{"@type":"Dictionary","@":[{"@type":"Association","key":1,"value":2,"@id":2}],"@id":1}')
		equals: collection.
	self
		assert: (self materialize: '{"@type":"Dictionary","@":[],"@id":1}')
		equals: STON mapClass new
]

{ #category : 'tests' }
JacksonReaderTest >> testDictionaryWithComplexKeys [

	| collection |
	collection := OrderedDictionary new
		              at: true put: 1;
		              at: #( foo ) put: 2;
		              yourself.
	self
		assert: (self materialize:
				 '{"@type":"OrderedDictionary","@":[{"@type":"Association","key":true,"value":1,"@id":2},{"@type":"Association","key":[4,{"@type":"ByteSymbol","value":"foo","@id":5}],"value":2,"@id":3}],"@id":1}')
		equals: collection
]

{ #category : 'tests' }
JacksonReaderTest >> testDiskFile [

	self
		assert: (self materialize:
				 '{"@type":"FileReference","path":"/test/foo.txt","@id":1}')
		equals: '/test/foo.txt' asFileReference.
	self
		assert: (self materialize:
				 '{"@type":"FileReference","path":"/tmp/foo.txt","@id":1}')
		equals: '/tmp/foo.txt' asFileReference.
	self
		assert: (self materialize:
				 '{"@type":"FileReference","path":"tmp/foo.txt","@id":1}')
		equals: 'tmp/foo.txt' asFileReference.
	self
		assert:
		(self materialize: '{"@type":"FileReference","path":"/tmp","@id":1}')
		equals: '/tmp' asFileReference.
	self
		assert:
		(self materialize: '{"@type":"FileReference","path":"/tmp","@id":1}')
		equals: '/tmp/' asFileReference
]

{ #category : 'tests' }
JacksonReaderTest >> testFloat [

	self assert: (self materialize: '1.5') equals: 1.5.
	self assert: (self materialize: '0.0') equals: 0.0.
	self assert: (self materialize: '-1.5') equals: -1.5.
	self assert: (self materialize: '3.14159') closeTo: Float pi.
	self assert: (self materialize: '0.333') closeTo: (1 / 3) asFloat.
	self
		assert: (self materialize: '1.0e100')
		equals: (10 raisedTo: 100) asFloat.
	self
		assert: (self materialize: '1.0e-50')
		equals: (10 raisedTo: -50) asFloat.
	self
		assert: (self materialize: '-1.0e-50')
		equals: (10 raisedTo: -50) asFloat negated.
	self
		assert: (self materialize: '{"@type":"Float","value":"nan"}')
		equals: Float nan.
	self
		assert: (self materialize: '{"@type":"Float","value":"infinity"}')
		equals: Float infinity.
	self
		assert:
		(self materialize: '{"@type":"Float","value":"negativeInfinity"}')
		equals: Float negativeInfinity
]

{ #category : 'tests' }
JacksonReaderTest >> testFraction [

	self
		assert: (self materialize:
				 '{"@type":"Fraction","numerator":1,"denominator":3,"@id":1}')
		equals: 1 / 3.
	self
		assert: (self materialize:
				 '{"@type":"Fraction","numerator":-8,"denominator":5,"@id":1}')
		equals: -8 / 5
]

{ #category : 'tests' }
JacksonReaderTest >> testId [

	| user |
	(user := STONTestUser new)
		username: 'john@foo.com';
		password: 'secret1'.
	self
		assert: (self materialize:
				 '{"@type":"STONTestUser","username":"john@foo.com","password":"secret1","enabled":true,"@id":1}')
		equals: user.
	(user := STONTestUser new)
		username: 'john2@foo.com';
		password: 'secret2'.
	self
		assert: (self materialize:
				 '{"@type":"STONTestUser","username":"john2@foo.com","password":"secret2","enabled":true,"@id":1}')
		equals: user
]

{ #category : 'tests' }
JacksonReaderTest >> testIdWhenNestedReference [

	| user array |
	(user := STONTestUser new)
		username: 'john@foo.com';
		password: 'secret1'.
	self
		assert: (self materialize:
				 '{"@type":"STONTestUser","username":"john@foo.com","password":"secret1","enabled":true,"@id":1}')
		equals: user.
	array := (Array new: 5)
		         at: 1 put: user;
		         at: 4 put: user;
		         yourself.
	array at: 3 put: array.
	self
		assert: (self materialize:
				 '[1,{"@type":"STONTestUser","username":"john@foo.com","password":"secret1","enabled":true,"@id":2},null,{"@ref":1},{"@ref":2},null]')
		equals: array
]

{ #category : 'tests' }
JacksonReaderTest >> testIdWhenReference [

	| user |
	(user := STONTestUser new)
		username: 'john@foo.com';
		password: 'secret1'.
	self
		assert: (self materialize:
				 '[1,{"@type":"STONTestUser","username":"john@foo.com","password":"secret1","enabled":true,"@id":2},{"@ref":2}]')
		equals: {
				user.
				user }
]

{ #category : 'tests' }
JacksonReaderTest >> testIdentityDictionary [

	| collection |
	collection := IdentityDictionary new
		              at: 1 put: 1;
		              at: 2 put: 2;
		              yourself.
	self
		assert: (self materialize:
				 '{"@type":"IdentityDictionary","tally":2,"array":[2,{"@type":"Association","key":1,"value":1,"@id":3},{"@type":"Association","key":2,"value":2,"@id":4},null,null,null],"@id":1}')
		equals: collection.
	self
		assert: (self materialize:
				 '{"@type":"IdentityDictionary","tally":0,"array":[2,null,null,null,null,null],"@id":1}')
		equals: IdentityDictionary new
]

{ #category : 'tests' }
JacksonReaderTest >> testLinkedList [

	| collection |
	self
		assert: (self materialize:
				 '{"@type":"LinkedList","firstLink":null,"lastLink":null,"@id":1}')
		equals: LinkedList new.
	collection := LinkedList
		              with: 1
		              with: 2
		              with: 3
		              with: nil.
	self
		assert: (self materialize:
				 '{"@type":"LinkedList","firstLink":{"@type":"ValueLink","nextLink":{"@type":"ValueLink","nextLink":{"@type":"ValueLink","nextLink":{"@type":"ValueLink","nextLink":null,"value":null,"@id":5},"value":3,"@id":4},"value":2,"@id":3},"value":1,"@id":2},"lastLink":{"@ref":5},"@id":1}')
		equals: collection
]

{ #category : 'tests' }
JacksonReaderTest >> testList [

	self assert: (self materialize: '[1]') equals: STON listClass new.
	self
		assert: (self materialize: '[1,1,2,3]')
		equals: (STON listClass withAll: #( 1 2 3 )).
	self
		assert: (self materialize:
				 '[1,1,-1,0,{"@type":"ByteSymbol","value":"foo","@id":2},"a b c",true,false,null]')
		equals:
		(STON listClass withAll:
			 { 1. -1. 0. #foo. 'a b c'. true. false. nil })
]

{ #category : 'tests' }
JacksonReaderTest >> testMap [

	| map |
	(map := STON mapClass new)
		at: #foo put: 1;
		at: #bar put: 2;
		at: 5 put: 0.
	self
		assert: (self materialize:
				 '{"@type":"Dictionary","@":[{"@type":"Association","key":5,"value":0,"@id":2},{"@type":"Association","key":{"@type":"ByteSymbol","value":"foo","@id":4},"value":1,"@id":3},{"@type":"Association","key":{"@type":"ByteSymbol","value":"bar","@id":6},"value":2,"@id":5}],"@id":1}')
		equals: map.
	map removeAll.
	self
		assert: (self materialize: '{"@type":"Dictionary","@":[],"@id":1}')
		equals: map.
	map at: 'foo bar' put: #ok.
	self
		assert: (self materialize:
				 '{"@type":"Dictionary","@":[{"@type":"Association","key":"foo bar","value":{"@type":"ByteSymbol","value":"ok","@id":3},"@id":2}],"@id":1}')
		equals: map.
	map removeAll.
	map at: 123 put: 456.
	self
		assert: (self materialize:
				 '{"@type":"Dictionary","@":[{"@type":"Association","key":123,"value":456,"@id":2}],"@id":1}')
		equals: map
]

{ #category : 'tests' }
JacksonReaderTest >> testMimeType [

	self
		assert: (self materialize:
				 '{"@type":"ZnMimeType","main":"application","sub":"json","parameters":null,"@id":1}')
		equals: ZnMimeType applicationJson.
	self
		assert: (self materialize:
				 '{"@type":"ZnMimeType","main":"text","sub":"plain","parameters":{"@type":"SmallDictionary","keys":[3,"charset",null],"values":[4,"utf-8",null],"size":1,"@id":2},"@id":1}')
		equals: ZnMimeType textPlain
]

{ #category : 'running' }
JacksonReaderTest >> testNil [

	self assert: (self materialize: 'null') equals: nil
]

{ #category : 'running' }
JacksonReaderTest >> testNumber [

	self assert: (self materialize: '1') equals: 1.
	self assert: (self materialize: '-8') equals: -8
]

{ #category : 'tests' }
JacksonReaderTest >> testObjectWithNoInstVars [

	self
		assert:
		(self materialize: '{"@type":"MockClassWithNoInstVars","@id":1}')
		equals: MockClassWithNoInstVars new
]

{ #category : 'tests' }
JacksonReaderTest >> testOrderedCollection [

	| collection |
	collection := OrderedCollection
		              with: 1
		              with: 2
		              with: 3
		              with: nil.
	self
		assert: (self materialize:
				 '{"@type":"OrderedCollection","@":[1,2,3,null],"@id":1}')
		equals: collection.
	self
		assert:
		(self materialize: '{"@type":"OrderedCollection","@":[],"@id":1}')
		equals: OrderedCollection new
]

{ #category : 'tests' }
JacksonReaderTest >> testPoint [

	self
		assert: (self materialize: '{"@type":"Point","x":1,"y":2,"@id":1}')
		equals: 1 @ 2
]

{ #category : 'tests' }
JacksonReaderTest >> testReferenceCycle [

	| array |
	array := STON listClass with: 1 with: nil.
	array at: 2 put: array.
	self assert: (self materialize: '[1,1,{"@ref":1}]') equals: array
]

{ #category : 'tests' }
JacksonReaderTest >> testReferenceSharing [

	| array one |
	one := { #one }.
	array := STON listClass with: one with: one with: one.
	self
		assert: (self materialize:
				 '[1,[2,{"@type":"ByteSymbol","value":"one","@id":3}],{"@ref":2},{"@ref":2}]')
		equals: array
]

{ #category : 'tests' }
JacksonReaderTest >> testScaledDecimal [

	self
		assert: (self materialize:
				 '{"@type":"ScaledDecimal","numerator":1,"denominator":3,"scale":2,"@id":1}')
		equals: 1 / 3s2.
	self
		assert: (self materialize:
				 '{"@type":"ScaledDecimal","numerator":-1,"denominator":3,"scale":2,"@id":1}')
		equals: -1 / 3s2.
	self
		assert: (self materialize:
				 '{"@type":"ScaledDecimal","numerator":1,"denominator":3,"scale":10,"@id":1}')
		equals: 1 / 3s10.
	self
		assert: (self materialize:
				 '{"@type":"ScaledDecimal","numerator":-1,"denominator":3,"scale":10,"@id":1}')
		equals: -1 / 3s10
]

{ #category : 'tests' }
JacksonReaderTest >> testSet [

	| collection |
	collection := Set
		              with: 1
		              with: 2
		              with: 3
		              with: nil.
	self
		assert:
		(self materialize: '{"@type":"Set","@":[1,2,3,null],"@id":1}')
		equals: collection.
	self
		assert: (self materialize: '{"@type":"Set","@":[],"@id":1}')
		equals: Set new
]

{ #category : 'running' }
JacksonReaderTest >> testString [

	self assert: (self materialize: '"foo"') equals: 'foo'.
	self assert: (self materialize: '"FOO"') equals: 'FOO'.
	self
		assert: (self materialize: '"élève en Français"')
		equals: 'élève en Français'.
	self assert: (self materialize: '"\s\t"') equals: ' 	'
]

{ #category : 'tests' }
JacksonReaderTest >> testSymbol [

	self
		assert:
		(self materialize: '{"@type":"ByteSymbol","value":"foo","@id":1}')
		equals: #foo.
	self
		assert:
		(self materialize: '{"@type":"ByteSymbol","value":"FOO","@id":1}')
		equals: #FOO.
	self
		assert:
		(self materialize: '{"@type":"ByteSymbol","value":"bytes","@id":1}')
		equals: #bytes.
	self
		assert:
		(self materialize:
			 '{"@type":"ByteSymbol","value":"foo.bar","@id":1}')
		equals: #'foo.bar'.
	self
		assert:
		(self materialize:
			 '{"@type":"ByteSymbol","value":"foo-bar","@id":1}')
		equals: #'foo-bar'.
	self
		assert:
		(self materialize:
			 '{"@type":"ByteSymbol","value":"foo_bar","@id":1}')
		equals: #foo_bar.
	self
		assert:
		(self materialize:
			 '{"@type":"ByteSymbol","value":"foo/bar","@id":1}')
		equals: #'foo/bar'.
	self
		assert:
		(self materialize:
			 '{"@type":"ByteSymbol","value":"foo bar","@id":1}')
		equals: #'foo bar'.
	self
		assert:
		(self materialize: '{"@type":"ByteSymbol","value":"foo123","@id":1}')
		equals: #foo123
]

{ #category : 'tests' }
JacksonReaderTest >> testTime [

	| time |
	time := Time hour: 6 minute: 30 second: 15.
	self
		assert: (self materialize:
				 '{"@type":"Time","seconds":23415,"nanos":0,"@id":1}')
		equals: time.
	time := Time
		        hour: 6
		        minute: 30
		        second: 15
		        nanoSecond: 123.
	self
		assert: (self materialize:
				 '{"@type":"Time","seconds":23415,"nanos":123,"@id":1}')
		equals: time
]

{ #category : 'tests' }
JacksonReaderTest >> testURL [

	self
		assert: (self materialize:
				 '{"@type":"ZnUrl","scheme":{"@type":"ByteSymbol","value":"https","@id":2},"host":"pharo.org","port":null,"segments":{"@type":"OrderedCollection","@":["files","pharo.png"],"@id":3},"query":null,"fragment":null,"username":null,"password":null,"@id":1}')
		equals: 'https://pharo.org/files/pharo.png' asUrl.
	self
		assert: (self materialize:
				 '{"@type":"ZnUrl","scheme":{"@type":"ByteSymbol","value":"mailto","@id":2},"host":"stfx.eu","port":null,"segments":null,"query":null,"fragment":null,"username":"sven","password":null,"@id":1}')
		equals: 'mailto:sven@stfx.eu' asUrl.
	self
		assert: (self materialize:
				 '{"@type":"ZnUrl","scheme":{"@type":"ByteSymbol","value":"file","@id":2},"host":null,"port":null,"segments":{"@type":"OrderedCollection","@":["var","log","system.log"],"@id":3},"query":null,"fragment":null,"username":null,"password":null,"@id":1}')
		equals: 'file:///var/log/system.log' asUrl.
	self
		assert: (self materialize:
				 '{"@type":"ZnUrl","scheme":{"@type":"ByteSymbol","value":"scheme","@id":2},"host":"host","port":123,"segments":{"@type":"OrderedCollection","@":["var","log","system.log"],"@id":3},"query":{"@type":"ZnMultiValueDictionary","dictionary":{"@type":"Dictionary","@":[{"@type":"Association","key":"bar","value":null,"@id":6},{"@type":"Association","key":"foo","value":"1","@id":7}],"@id":5},"orderedKeys":[8,"foo","bar",null,null,null,null,null,null,null,null],"limit":256,"@id":4},"fragment":"frag","username":"user","password":"password","@id":1}')
		equals:
			'scheme://user:password@host:123/var/log/system.log?foo=1&bar#frag'
				asUrl
]

{ #category : 'tests' }
JacksonReaderTest >> testUser [

	| user |
	(user := STONTestUser new)
		username: 'john@foo.com';
		password: 'secret1'.
	self
		assert: (self materialize:
				 '{"@type":"STONTestUser","username":"john@foo.com","password":"secret1","enabled":true,"@id":1}')
		equals: user
]

{ #category : 'tests' }
JacksonReaderTest >> testUser2 [

	| user |
	(user := STONTestUser2 new)
		username: 'john@foo.com';
		password: 'secret1'.
	self
		assert: (self materialize:
				 '{"@type":"STONTestUser2","username":"john@foo.com","password":"secret1","enabled":true,"@id":1}')
		equals: user
]

{ #category : 'tests' }
JacksonReaderTest >> testUser3Nil [

	| user |
	user := STONTestUser3 new.
	self
		assert: (self materialize:
				 '{"@type":"STONTestUser3","username":null,"password":null,"enabled":true,"@id":1}')
		equals: user
]

{ #category : 'tests' }
JacksonReaderTest >> testUserNil [

	| user |
	user := STONTestUser new.
	self
		assert: (self materialize:
				 '{"@type":"STONTestUser","username":null,"password":null,"enabled":true,"@id":1}')
		equals: user
]

{ #category : 'tests' }
JacksonReaderTest >> testWriteCollectionInnerArray [

	| collection |
	collection := {
		              'lostArrayRefButNotElements'.
		              Object new }.
	self
		assert: (self materialize:
				 '[1,[2,"lostArrayRefButNotElements",{"@type":"Object","@id":3}],{"@type":"OrderedCollection","@":["lostArrayRefButNotElements",{"@ref":3}],"@id":4}]')
		equals: {
				collection.
				(OrderedCollection new setContents: collection) }
]
