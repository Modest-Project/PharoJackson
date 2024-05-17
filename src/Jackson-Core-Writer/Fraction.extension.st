Extension { #name : 'Fraction' }

{ #category : '*Jackson-Core-Writer' }
Fraction >> jacksonOn: jacksonWriter [
	jacksonWriter writeObject: self
]
