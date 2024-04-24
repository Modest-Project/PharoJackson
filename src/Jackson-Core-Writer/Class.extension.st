Extension { #name : #Class }

{ #category : #'*Jackson-Core-Writer' }
Class >> jacksonOn: jacksonWriter [
	jacksonWriter
		writeObject: self
		listSingleton: self name asSymbol
]
