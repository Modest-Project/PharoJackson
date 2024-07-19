Class {
	#name : 'JacksonReader',
	#superclass : 'STONWriter',
	#instVars : [
		'readStream',
		'stringStream'
	],
	#category : 'Jackson-Core',
	#package : 'Jackson-Core'
}

{ #category : 'instance creation' }
JacksonReader class >> fromString: string [

	^ (self on: string readStream) next
]

{ #category : 'private - initialization' }
JacksonReader >> consumeWhitespace [
	"Strip whitespaces from the input stream."

	[ readStream atEnd not and: [ readStream peek isSeparator ] ]
		whileTrue: [ readStream next ]
]

{ #category : 'private - initialization' }
JacksonReader >> expectChar: character [
	"Expect character and consume input and optional whitespace at the end,
	 throw an error otherwise."

	(self matchChar: character) ifFalse: [
		self error: character asString , ' expected' ]
]

{ #category : 'private - initialization' }
JacksonReader >> match: string do: block [
	"Try to read and consume string and execute block if successful.
	Else do nothing (but do not back up)"

	(string allSatisfy: [ :each | readStream peekFor: each ]) ifTrue: [
		self consumeWhitespace.
		block value ]
]

{ #category : 'private - initialization' }
JacksonReader >> matchChar: character [
	"Tries to match character, consume input and
	answer true if successful and consumes whitespace at the end."

	^ (readStream peekFor: character)
		  ifTrue: [
			  self consumeWhitespace.
			  true ]
		  ifFalse: [ false ]
]

{ #category : 'private - initialization' }
JacksonReader >> next [

	^ self
		  consumeWhitespace;
		  parseValue
]

{ #category : 'private - initialization' }
JacksonReader >> on: aReadStream [

	readStream := aReadStream
]

{ #category : 'private - initialization' }
JacksonReader >> parseCharacter [

	| char |
	^ (char := readStream next) = $\
		  ifTrue: [ self parseEscapedCharacter ]
		  ifFalse: [ char ]
]

{ #category : 'private - initialization' }
JacksonReader >> parseCharacterHex [

	| value codePoint |
	value := self parseCharacterHex4Value.
	(value < 16rD800 or: [ value > 16rDBFF ])
		ifTrue: [ codePoint := value ]
		ifFalse: [
			| leadSurrogate trailSurrogate |
			"Characters not in the Basic Multilingual Plane are encoded as a UTF-16 surrogate pair""See https://tools.ietf.org/html/rfc7159#section-7"
			leadSurrogate := value.
			trailSurrogate := self parseTrailingSurrogateHexEscape.
			codePoint := leadSurrogate - 16rD800 * 16r400
			             + (trailSurrogate - 16rDC00).
			codePoint := 16r10000 + codePoint ].
	^ Character codePoint: codePoint
]

{ #category : 'private - initialization' }
JacksonReader >> parseCharacterHex4Value [

	| value |
	value := self parseCharacterHexDigit.
	3 timesRepeat: [ value := value << 4 + self parseCharacterHexDigit ].
	^ value
]

{ #category : 'private - initialization' }
JacksonReader >> parseCharacterHexDigit [

	| digit |
	readStream atEnd ifFalse: [
		digit := readStream next asInteger.
		(digit between: 48 and: 57) ifTrue: [ "0-9" ^ digit - 48 ].
		(digit between: 65 and: 70) ifTrue: [ "A-F" ^ digit - 55 ].
		(digit between: 97 and: 102) ifTrue: [ "a-f" ^ digit - 87 ] ].
	self error: 'hex-digit expected'
]

{ #category : 'private - initialization' }
JacksonReader >> parseConstantDo: block [
	"Parse and consume either true|false|nil|null and execute block
	or else do nothing (but do not back up).
	Hand written implementation to avoid the use of #position:"

	readStream peek = $t ifTrue: [
		^ self match: 'true' do: [ block value: true ] ].
	readStream peek = $f ifTrue: [
		^ self match: 'false' do: [ block value: false ] ].
	readStream peek = $n ifTrue: [
		^ self match: 'null' do: [ block value: nil ] ]
]

{ #category : 'private - initialization' }
JacksonReader >> parseEscapedCharacter [

	| char |
	char := readStream next.
	(#( $' $" $/ $\ ) includes: char) ifTrue: [ ^ char ].
	char = $b ifTrue: [ ^ Character backspace ].
	char = $f ifTrue: [ ^ Character newPage ].
	char = $n ifTrue: [ ^ Character lf ].
	char = $r ifTrue: [ ^ Character cr ].
	char = $t ifTrue: [ ^ Character tab ].
	char = $u ifTrue: [ ^ self parseCharacterHex ].
	char = $s ifTrue: [ ^ Character space ].
	self error: 'invalid escape character \' , (String with: char).
	^ char
]

{ #category : 'private - initialization' }
JacksonReader >> parseNumber [

	| negated number |
	negated := readStream peekFor: $-.
	number := self parseNumberInteger.
	(readStream peekFor: $/) ifTrue: [
		number := Fraction
			          numerator: number
			          denominator: self parseNumberInteger.
		(readStream peekFor: $s) ifTrue: [
			number := ScaledDecimal
				          newFromNumber: number
				          scale: self parseNumberInteger ] ].
	negated ifTrue: [ number := number negated ].
	self consumeWhitespace.
	^ number
]

{ #category : 'private - initialization' }
JacksonReader >> parseNumberExponent [

	| number negated |
	number := 0.
	(negated := readStream peekFor: $-) ifFalse: [
		readStream peekFor: $+ ].
	[ readStream atEnd not and: [ readStream peek isDigit ] ] whileTrue: [
		number := 10 * number + readStream next digitValue ].
	negated ifTrue: [ number := number negated ].
	^ 10 raisedTo: number
]

{ #category : 'private - initialization' }
JacksonReader >> parseNumberInteger [

	| number |
	number := 0.
	[ readStream atEnd not and: [ readStream peek isDigit ] ] whileTrue: [
		number := 10 * number + readStream next digitValue ].
	^ number
]

{ #category : 'private - initialization' }
JacksonReader >> parseString [

	| result |
	readStream next.
	result := self stringStreamContents: [ :stream |
		          [ readStream atEnd or: [ readStream peek == $" ] ]
			          whileFalse: [ stream nextPut: self parseCharacter ] ].
	self expectChar: $".
	^ result
]

{ #category : 'private - initialization' }
JacksonReader >> parseValue [

	| char |
	readStream atEnd ifFalse: [
		char := readStream peek.
		char = ${ ifTrue: [ ^ self parseObject ].
		char = $[ ifTrue: [ ^ self parseList ].
		char = $" ifTrue: [ ^ self parseString ].
		(char = $- or: [ char isDigit ]) ifTrue: [ ^ self parseNumber ].
		self parseConstantDo: [ :value | ^ value ] ].
	self error: 'invalid input: ' , char asString
]

{ #category : 'private - initialization' }
JacksonReader >> stringStreamContents: block [

	stringStream
		ifNil: [ stringStream := (String new: 32) writeStream ]
		ifNotNil: [ stringStream reset ].
	block value: stringStream.
	^ stringStream contents
]
