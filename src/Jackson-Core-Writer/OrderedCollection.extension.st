Extension { #name : 'OrderedCollection' }

{ #category : '*Jackson-Core-Writer' }
OrderedCollection >> jacksonOn: jacksonWriter [

	jacksonWriter writeCollection: self
]
