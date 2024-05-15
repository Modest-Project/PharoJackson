Extension { #name : 'Integer' }

{ #category : '*Jackson-Core-Writer' }
Integer >> jacksonOn: jacksonWriter [
	jacksonWriter writeInteger: self
]
