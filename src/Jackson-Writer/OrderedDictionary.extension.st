Extension { #name : 'OrderedDictionary' }

{ #category : '*Jackson-Writer' }
OrderedDictionary >> jacksonOn: jacksonWriter [

	self class == OrderedDictionary
		ifTrue: [ jacksonWriter writeMap: self ]
		ifFalse: [ super jacksonOn: jacksonWriter ]
]
