Extension { #name : 'Symbol' }

{ #category : '*Jackson-Writer' }
Symbol >> jacksonOn: jacksonWriter [
	jacksonWriter writeSymbol: self
]
