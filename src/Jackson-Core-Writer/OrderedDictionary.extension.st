Extension { #name : 'OrderedDictionary' }

{ #category : '*Jackson-Core-Writer' }
OrderedDictionary >> jacksonOn: jacksonWriter [

	self class == OrderedDictionary
		ifTrue: [ jacksonWriter writeMap: self ]
		ifFalse: [ super jacksonOn: jacksonWriter ]
]
