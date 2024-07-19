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
	"An optimization for encoding a kind of array-wrapping Collection, e.g. Set.
	Its value is encoded as the meta-property '@' holding the elements."

	writeStream nextPutAll: '"@":['.
	collection
		do: [ :element | self nextPut: element ]
		separatedBy: [ writeStream nextPut: $, ].
	writeStream nextPut: $]
]

{ #category : 'writing' }
JacksonWriter >> encodeIndexable: anIndexable [
	"An indexable is an object with type and id metadata but without inst vars.
	Instead, it has a variable number of indexable fields (see VariableLayout), e.g. Path.
	Its value is encoded as the meta-property '@' holding the field array."

	writeStream nextPutAll: '"@":['.
	1 to: anIndexable basicSize do: [ :i |
		i == 1 ifFalse: [ writeStream nextPut: $, ].
		self nextPut: (anIndexable basicAt: i) ].
	writeStream nextPut: $]
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
	"Only Arrays are represented with this method.
	Encoded with its id as first element, followed by the array elements."

	writeStream nextPut: $[.
	writeStream print: objects size. "the id"
	elements do: [ :each |
		writeStream nextPut: $,.
		self nextPut: each ].
	writeStream nextPut: $]
]

{ #category : 'writing' }
JacksonWriter >> encodeMap: pairs [
	"An optimization for encoding a kind of key-value Collection, e.g. Dictionary.
	Its value is encoded as the meta-property '@' holding the Associations."

	| first |
	writeStream nextPutAll: '"@":['.
	first := true.
	pairs associationsDo: [ :association |
		first
			ifTrue: [ first := false ]
			ifFalse: [ writeStream nextPut: $, ].
		self writeAssociation: association ].
	writeStream nextPut: $]
]

{ #category : 'writing' }
JacksonWriter >> encodeObject: anObject [

	| first |
	first := true.
	anObject class allInstVarNames do: [ :varName |
		| value |
		value := anObject instVarNamed: varName.
		first
			ifTrue: [ first := false ]
			ifFalse: [ writeStream nextPut: $, ].
		writeStream nextPut: $".
		writeStream nextPutAll: varName.
		writeStream nextPutAll: '":'.
		self nextPut: value ]
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

	objects
		at: object
		ifPresent: [ :index | self writeReference: index ]
		ifAbsent: [
			objects at: object put: objects size + 1.
			block value ]
]

{ #category : 'writing' }
JacksonWriter >> writeAssociation: association [

	self writeObject: association streamMap: [ :map |
		map at: 'key' put: association key.
		map at: 'value' put: association value ]
]

{ #category : 'writing' }
JacksonWriter >> writeCharacter: character [

	writeStream nextPutAll: '{"@type":"Character","value":'.
	writeStream print: character asciiValue.
	writeStream nextPut: $}
]

{ #category : 'writing' }
JacksonWriter >> writeClass: aClass [

	writeStream nextPutAll: '{"@type":"Class","name":"'.
	writeStream nextPutAll: aClass name.
	writeStream nextPutAll: '"}'
]

{ #category : 'writing' }
JacksonWriter >> writeCollection: collection [

	self
		writeObject: collection
		do: [ self encodeCollection: collection ]
]

{ #category : 'writing' }
JacksonWriter >> writeCompiledBlock: aCompiledBlock [

	self writeObject: aCompiledBlock do: [
		aCompiledBlock sourceNode ifNotNil: [ :source |
			writeStream nextPutAll: '"source":'.
			self encodeString: source sourceCode ].

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
JacksonWriter >> writeCompiledCode: aCompiledCode [

	self shouldBeImplemented
]

{ #category : 'writing' }
JacksonWriter >> writeFloat: float [

	float isFinite
		ifTrue: [ writeStream print: float ]
		ifFalse: [
			writeStream nextPutAll: '{"@type":"Float","value":"'.
			writeStream nextPutAll: (float isNaN
					 ifTrue: [ #nan ]
					 ifFalse: [
						 float negative
							 ifTrue: [ #negativeInfinity ]
							 ifFalse: [ #infinity ] ]).
			writeStream nextPutAll: '"}' ]
]

{ #category : 'writing' }
JacksonWriter >> writeFraction: fraction [

	self shouldNotImplement
]

{ #category : 'writing' }
JacksonWriter >> writeFullBlockClosure: aFullBlockClosure [
	"Serialize bound variables and ignore outerContext."

	self writeObject: aFullBlockClosure do: [
		aFullBlockClosure compiledBlock ifNotNil: [ :compiledBlock |
			writeStream nextPutAll: '"compiledBlock":'.
			self writeCompiledBlock: compiledBlock.
			self writeFullBlockClosureVars: aFullBlockClosure ].

		writeStream nextPutAll: ',"numArgs":'.
		writeStream print: aFullBlockClosure numArgs.

		"serialize receiver if it is read"
		aFullBlockClosure receiver ifNotNil: [ :receiver |
			aFullBlockClosure compiledBlock readsSelf ifTrue: [
				writeStream nextPutAll: ',"receiver":'.
				self nextPut: receiver ] ] ]
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
JacksonWriter >> writeIndexable: anIndexable [

	self
		writeObject: anIndexable
		do: [ self encodeIndexable: anIndexable ]
]

{ #category : 'writing' }
JacksonWriter >> writeIndexableObject: indexableObject [

	self writeObject: indexableObject do: [
		self encodeIndexable: indexableObject.
		self encodeObject: indexableObject ]
]

{ #category : 'writing' }
JacksonWriter >> writeMap: hashedCollection [

	self
		writeObject: hashedCollection
		do: [ self encodeMap: hashedCollection ]
]

{ #category : 'writing' }
JacksonWriter >> writeNull [

	writeStream nextPutAll: 'null'
]

{ #category : 'writing' }
JacksonWriter >> writeObject: anObject [

	self writeObject: anObject do: [ self encodeObject: anObject ]
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

	self shouldNotImplement
]

{ #category : 'writing' }
JacksonWriter >> writeSymbol: aSymbol [

	self writeObject: aSymbol do: [
		writeStream nextPutAll: '"value":'.
		self encodeString: aSymbol ]
]
