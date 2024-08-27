Extension { #name : 'Integer' }

{ #category : '*Jackson-Writer' }
Integer >> jacksonOn: jacksonWriter [
	jacksonWriter writeInteger: self
]
