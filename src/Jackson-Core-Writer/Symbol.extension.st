Extension { #name : #Symbol }

{ #category : #'*Jackson-Core-Writer' }
Symbol >> jacksonOn: jacksonWriter [
	jacksonWriter writeSymbol: self
]
