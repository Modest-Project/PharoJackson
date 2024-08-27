Extension { #name : 'Dictionary' }

{ #category : '*Jackson-Writer' }
Dictionary >> jacksonOn: jacksonWriter [

	self class == Dictionary
		ifTrue: [ jacksonWriter writeMap: self ]
		ifFalse: [ super jacksonOn: jacksonWriter ]
]
