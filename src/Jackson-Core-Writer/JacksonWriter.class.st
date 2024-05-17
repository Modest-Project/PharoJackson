Class {
	#name : 'JacksonWriter',
	#superclass : 'STONWriter',
	#category : 'Jackson-Core-Writer',
	#package : 'Jackson-Core-Writer'
}

{ #category : 'private' }
JacksonWriter class >> serialize: anObject [

	^ String streamContents: [ :stream |
		  self new
			  on: stream;
			  nextPut: anObject ]
]

{ #category : 'writing' }
JacksonWriter >> encodeCollection: collection [

	writeStream nextPut: ${.
	self writeAssociation: '@type' -> collection className.
	self mapElementSeparator.
	self writeAssociation: '@id' -> objects size.
	self mapElementSeparator.
	self writeString: 'array'.
	writeStream nextPut: $:.
	self writeList: collection asArray.
	writeStream nextPut: $}
]

{ #category : 'private' }
JacksonWriter >> encodeKey: key value: value [
	"For Json key/value like @type or fields"

	self nextPut: key.
	writeStream nextPut: $:.
	self nextPut: value
]

{ #category : 'writing' }
JacksonWriter >> encodeList: elements [

	writeStream nextPut: $[.
	writeStream print: objects size.
	elements isEmpty
		ifFalse: [
			self listElementSeparator. "For the id"
			self indentedDo: [
				elements
					do: [ :each | self nextPut: each ]
					separatedBy: [ self listElementSeparator ] ]].
	writeStream nextPut: $]
]

{ #category : 'private' }
JacksonWriter >> encodeMapKey: key value: value [
	"For Dictionary key/value"
	
	writeStream nextPut: $[.
	self nextPut: key.
	self listElementSeparator.
	self nextPut: value.
	writeStream nextPut: $]
]

{ #category : 'private' }
JacksonWriter >> encodeString: string [
	writeStream nextPut: $".
	keepNewLines
		ifTrue: [
			self encodeStringKeepingNewLines: string ]
		ifFalse: [
			string do: [ :each | self encodeCharacter: each ] ].
	writeStream nextPut: $"
]

{ #category : 'initialization' }
JacksonWriter >> initialize [

	super initialize.
	self jsonMode: true
]

{ #category : 'public' }
JacksonWriter >> nextPut: anObject [

	anObject jacksonOn: self
]

{ #category : 'private' }
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

{ #category : 'writing' }
JacksonWriter >> writeAssociation: association [

	self encodeKey: association key value: association value
]

{ #category : 'writing' }
JacksonWriter >> writeCharacter: character [

	writeStream nextPut: ${.
	self writeAssociation: '@type' -> character className.
	self mapElementSeparator.
	self writeString: 'value'.
	writeStream nextPut: $:.
	self writeInteger: character asciiValue.
	writeStream nextPut: $}
]

{ #category : 'writing' }
JacksonWriter >> writeClass: aClass [

	writeStream nextPut: ${.
	self writeAssociation: '@type' -> 'Class'.
	self mapElementSeparator.
	self writeAssociation: 'name' -> aClass name.
	writeStream nextPut: $}
]

{ #category : 'writing' }
JacksonWriter >> writeCollection: collection [

	self with: collection do: [ self encodeCollection: collection ]
]

{ #category : 'writing' }
JacksonWriter >> writeCompiledBlock: aCompiledBlock [

	self writeObject: aCompiledBlock streamMap: [ :map |
		map at: 'source' put: aCompiledBlock sourceNode sourceCode.

		"serialize bound LiteralVariables"
		(aCompiledBlock literalsEvenTheOnesInTheInnerBlocks select: [
			 :literal | literal isVariableBinding ]) ifNotEmpty: [ :literals |
			writeStream nextPutAll: ',"literals":{'.
			literals
				do: [ :literal |
					writeStream nextPut: $".
					writeStream nextPutAll: literal name.
					writeStream nextPutAll: '":'.
					self nextPut: literal value ]
				separatedBy: [ writeStream nextPut: $, ].
			writeStream nextPut: $} ] ]
]

{ #category : 'writing' }
JacksonWriter >> writeFloat: float [

	float isFinite
		ifTrue: [ writeStream print: float ]
		ifFalse: [
			| argument |
			argument := float isNaN
				            ifTrue: [ #nan ]
				            ifFalse: [
					            float negative
						            ifTrue: [ #negativeInfinity ]
						            ifFalse: [ #infinity ] ].
			self writeString: argument ]
]

{ #category : 'writing' }
JacksonWriter >> writeFraction: fraction [

	writeStream
		print: fraction numerator;
		nextPut: $/;
		print: fraction denominator
]

{ #category : 'writing' }
JacksonWriter >> writeFullBlockClosure: aFullBlockClosure [
	"Serialize bound variables and ignore outerContext."

	self writeObject: aFullBlockClosure streamMap: [ :map |
		map at: 'compiledBlock' put: aFullBlockClosure compiledBlock.
		map at: 'numArgs' put: aFullBlockClosure numArgs.

		"serialize receiver if it is read"
		aFullBlockClosure receiver ifNotNil: [ :receiver |
			aFullBlockClosure compiledBlock readsSelf ifTrue: [
				map at: 'receiver' put: receiver ] ].

		self writeFullBlockClosureVars: aFullBlockClosure ]
]

{ #category : 'writing' }
JacksonWriter >> writeFullBlockClosureVars: aFullBlockClosure [
	"serialize variables, ignore (inner) block arguments and temporaries"

	| context vars |
	context := aFullBlockClosure outerContext.
	vars := OrderedCollection new.
	aFullBlockClosure sourceNode scope copiedVars do: [ :var |
		(context lookupVar: var name) ifNotNil: [ :ctxVar |
			vars addLast: ctxVar ] ].
	vars ifNotEmpty: [
		writeStream nextPutAll: ',"vars":{'.
		vars
			do: [ :var |
				writeStream nextPut: $".
				writeStream nextPutAll: var name.
				writeStream nextPutAll: '":'.
				self nextPut: (var readInContext: context) ]
			separatedBy: [ writeStream nextPut: $, ].
		writeStream nextPut: $} ]
]

{ #category : 'writing' }
JacksonWriter >> writeNull [

	writeStream nextPutAll: 'null'
]

{ #category : 'writing' }
JacksonWriter >> writeObject: anObject [

	self writeObject: anObject streamMap: [ :map |
		anObject class allInstVarNames do: [ :each |
			(anObject instVarNamed: each) ifNotNil: [ :value |
				map at: each asString put: value ] ] ]
]

{ #category : 'writing' }
JacksonWriter >> writeObject: object do: block [
	"No checks, everything can be serialized."

	self with: object do: [
		| id position |
		writeStream nextPutAll: '{"@type":"'.
		writeStream nextPutAll: object class name.
		writeStream nextPutAll: '",'.
		id := objects size.
		"check if anything was written to avoid trailing comma"
		position := writeStream position.
		block value.
		position = writeStream position ifFalse: [ writeStream nextPut: $, ].
		writeStream nextPutAll: '"@id":'.
		writeStream print: id.
		writeStream nextPut: $} ]
]

{ #category : 'writing' }
JacksonWriter >> writeObject: object streamMap: block [

	self
		writeObject: object
		do: [ block value: (STONMapWriter on: self) ]
]

{ #category : 'writing' }
JacksonWriter >> writeReference: index [

	writeStream
		nextPutAll: '{"@ref":';
		print: index;
		nextPut: $}
]

{ #category : 'writing' }
JacksonWriter >> writeScaledDecimal: scaledDecimal [

	writeStream
		print: scaledDecimal numerator;
		nextPut: $/;
		print: scaledDecimal denominator;
		nextPut: $s;
		print: scaledDecimal scale
]

{ #category : 'writing' }
JacksonWriter >> writeSymbol: aSymbol [

	self writeObject: aSymbol do: [
		writeStream nextPutAll: '"value":'.
		self encodeString: aSymbol ]
]
