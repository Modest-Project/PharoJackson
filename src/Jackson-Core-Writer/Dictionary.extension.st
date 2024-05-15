Extension { #name : 'Dictionary' }

{ #category : '*Jackson-Core-Writer' }
Dictionary >> jacksonOn: jacksonWriter [

	jacksonWriter writeMap: self
]
