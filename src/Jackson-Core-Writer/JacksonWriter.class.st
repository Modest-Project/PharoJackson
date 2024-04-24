Class {
	#name : #JacksonWriter,
	#superclass : #STONWriter,
	#category : #'Jackson-Core-Writer'
}

{ #category : #private }
JacksonWriter class >> serialize: anObject [

	^ String streamContents: [ :stream |
		  self new
			  on: stream;
			  nextPut: anObject ]
]

{ #category : #private }
JacksonWriter >> encodeCharacter: char [
	| code encoding |
	"STONCharacters contains for the lower 127 characters (codes 0 to 126) either nil (unknown),
	#pass (output as is, clean ASCII characters) or a full escape string"
	((code := char codePoint) < 127 and: [ (encoding := self stonCharacters at: code + 1) notNil ])
		ifTrue: [
			(encoding = #pass or: [ char = $' ] )
				ifTrue: [ writeStream nextPut: char ]
				ifFalse: [ writeStream nextPutAll: encoding ] ]
		ifFalse: [
			"always escape Latin1 C1 controls, or when asciiOnly is true"
			(code > 16r9F and: [ asciiOnly not ])
				ifTrue: [ writeStream nextPut: char ]
				ifFalse: [ self escapeUnicode: code ] ]
]

{ #category : #private }
JacksonWriter >> encodeKey: key value: value [

	self nextPut: key.
	self prettyPrintSpace.
	writeStream nextPut: $:.
	self prettyPrintSpace.
	self nextPut: value
]

{ #category : #writing }
JacksonWriter >> encodeMap: pairs [

	| first |
	first := true.
	writeStream nextPut: ${.
	self writeAssociation: '@id' -> (objects size).

	pairs isEmpty
		ifTrue: [ self prettyPrintSpace ]
		ifFalse: [
			self mapElementSeparator.
			self indentedDo: [
				self newlineIndent.
				pairs keysAndValuesDo: [ :key :value |
					first
						ifTrue: [ first := false ]
						ifFalse: [ self mapElementSeparator ].
					self encodeKey: key value: value ] ].
			self newlineIndent ].
	writeStream nextPut: $}
]

{ #category : #private }
JacksonWriter >> encodeString: string [
	writeStream nextPut: $".
	keepNewLines
		ifTrue: [
			self encodeStringKeepingNewLines: string ]
		ifFalse: [
			string do: [ :each | self encodeCharacter: each ] ].
	writeStream nextPut: $"
]

{ #category : #initialization }
JacksonWriter >> initialize [

	super initialize.
	jsonMode := true
]

{ #category : #public }
JacksonWriter >> nextPut: anObject [
	anObject jacksonOn: self
]

{ #category : #private }
JacksonWriter >> with: object do: block [

	| index |
	referencePolicy = #ignore ifTrue: [ ^ block value ].
	(index := objects at: object ifAbsent: [ nil ])
		ifNotNil: [
			referencePolicy = #error ifTrue: [
				^ self error: 'shared reference detected' ].
			self writeReference: index ]
		ifNil: [
			index := objects size + 1.
			objects at: object put: index.
			block value ]
]

{ #category : #writing }
JacksonWriter >> writeAssociation: association [

	self encodeKey: association key value: association value
]

{ #category : #writing }
JacksonWriter >> writeFraction: fraction [

	writeStream
		print: fraction numerator;
		nextPut: $/;
		print: fraction denominator
]

{ #category : #writing }
JacksonWriter >> writeNull [

	writeStream nextPutAll: 'null'
]

{ #category : #writing }
JacksonWriter >> writeObject: anObject do: block [
	self with: anObject do: [
		"although there is no check here, class names are expected to conform
		to first STONReader>>#isClassStartChar: then STONReader>>#isClassChar:"
		self prettyPrintSpace.
		block value ]
]

{ #category : #writing }
JacksonWriter >> writeObject: anObject named: stonName do: block [
	( anObject class ~= STON listClass and: [ anObject class ~= STON mapClass ] )
		ifTrue: [ self error: 'wrong object class for JSON mode' ].
	self with: anObject do: [
		writeStream nextPutAll: stonName.
		self prettyPrintSpace.
		block value ]
]

{ #category : #writing }
JacksonWriter >> writeObject: object streamMap: block [

	self writeObject: object do: [
		| mapWriter |
		mapWriter := STONMapWriter on: self.
		writeStream nextPut: ${.
		self writeAssociation: '@type' -> object className.
		self mapElementSeparator.
		self writeAssociation: '@id' -> (objects size).
		self mapElementSeparator.
		self indentedDo: [
			self newlineIndent.
			block value: mapWriter ].
		self newlineIndent.
		writeStream nextPut: $} ]
]

{ #category : #writing }
JacksonWriter >> writeReference: index [
	writeStream
		nextPutAll: '{"@ref":';
		print: index;
		nextPut: $}
]

{ #category : #writing }
JacksonWriter >> writeScaledDecimal: scaledDecimal [

	writeStream
		print: scaledDecimal numerator;
		nextPut: $/;
		print: scaledDecimal denominator;
		nextPut: $s;
		print: scaledDecimal scale
]

{ #category : #writing }
JacksonWriter >> writeSymbol: symbol [

	self writeString: symbol
]
