Class {
	#name : #JacksonReaderTest,
	#superclass : #STONWriterTest,
	#instVars : [
		'reader'
	],
	#category : #'Jackson-Core-Tests'
}

{ #category : #running }
JacksonReaderTest >> materialize: aString [

	^ reader
		  on: aString readStream;
		  next
]

{ #category : #running }
JacksonReaderTest >> setUp [

	super setUp.
	reader := JacksonReader new
]

{ #category : #running }
JacksonReaderTest >> testNil [

	self assert: (self materialize: 'null') equals: nil
]

{ #category : #running }
JacksonReaderTest >> testNumber [

	self assert: (self materialize: '1') equals: 1.
	self assert: (self materialize: '-8') equals: -8
]

{ #category : #running }
JacksonReaderTest >> testString [

	self assert: (self materialize: '"foo"') equals: 'foo'.
	self assert: (self materialize: '"FOO"') equals: 'FOO'.
	self
		assert: (self materialize: '"élève en Français"')
		equals: 'élève en Français'.
	self assert: (self materialize: '"\s\t"') equals: ' 	'
]
