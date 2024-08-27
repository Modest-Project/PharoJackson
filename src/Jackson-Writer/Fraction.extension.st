Extension { #name : 'Fraction' }

{ #category : '*Jackson-Writer' }
Fraction >> jacksonOn: jacksonWriter [
	jacksonWriter writeObject: self
]
